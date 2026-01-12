import Foundation

protocol ProductRepositoryProtocol {
    func loadProducts() async throws -> [Product]
    func loadProduct(handle: String) async throws -> Product
}

final class ProductRepository: ProductRepositoryProtocol {
    enum Error: Swift.Error {
        case unexpectedResponse
        case emptyData
        case unexpectedPayload
        case productNotFound
    }

    private let urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    func loadProducts() async throws -> [Product] {
        let (data, response) = try await urlSession.data(from: URL(string: "https://gist.githubusercontent.com/tsopin/22b7b6b32cef24dbf3dd98ffcfb63b1a/raw/6f379a4730ceb3c625afbcb0427ca9db7f7f3b8b/testProducts.json")!)
        guard
            let response = response as? HTTPURLResponse,
            (200..<400).contains(response.statusCode)
        else { throw Error.unexpectedResponse }

        let productPayloads = try JSONDecoder().decode([ProductPayload].self, from: data) // TODO: Remove from MainActor
        guard !productPayloads.isEmpty else { throw Error.emptyData }

        return try productPayloads.map(Product.init)
    }

    func loadProduct(handle: String) async throws -> Product {
        let products = try await loadProducts()

        guard let product = products.first(where: { $0.handle == handle }) else {
            throw Error.productNotFound
        }

        return product
    }
}

struct ProductPayload: Decodable {
    let handle: String
    let title: String
    let description: String
    let priceRange: PriceRange
    let images: [Image]

    struct PriceRange: Decodable {
        let maxVariantPrice: Money

        struct Money: Decodable {
            let amount: String
        }
    }

    struct Image: Decodable {
        let url: URL
    }
}

extension Product {
    init(payload: ProductPayload) throws {
        guard
            let price = Float(payload.priceRange.maxVariantPrice.amount),
            let imageURL = payload.images.first?.url
        else { throw ProductRepository.Error.unexpectedPayload }

        self = Self(
            handle: payload.handle,
            title: payload.title,
            description: payload.description,
            imageURL: imageURL,
            price: price
        )
    }
}

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}
extension URLSession: URLSessionProtocol {}
