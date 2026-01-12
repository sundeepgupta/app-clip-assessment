import Foundation
@testable import Reactiv
import Testing

struct ProductRepositoryTests {
    @Test(arguments: [199, 400]) func loadProucts_throwsOnInvalidStatusCode(statusCode: Int) async {
        let data = Data()
        let response = HTTPURLResponse.make(statusCode: statusCode)
        let sut = ProductRepository(urlSession: URLSessionMock(result: .success((data, response))))

        await #expect(throws: ProductRepository.Error.unexpectedResponse) {
            try await sut.loadProducts()
        }
    }

    @Test func loadProducts_throwsOnEmptyPayload() async {
        let data = Data("[]".utf8)
        let response = HTTPURLResponse.make(statusCode: 200)
        let sut = ProductRepository(urlSession: URLSessionMock(result: .success((data, response))))

        await #expect(throws: ProductRepository.Error.emptyData) {
            try await sut.loadProducts()
        }
    }

    @Test func loadProducts_success() async throws {
        let response = HTTPURLResponse.make(statusCode: 399)
        let sut = ProductRepository(urlSession: URLSessionMock(result: .success((productsData, response))))

        let result = try await sut.loadProducts()

        #expect(result == expectedProducts)
    }

    @Test func loadProduct_throwsWhenNotFound() async {
        let response = HTTPURLResponse.make(statusCode: 200)
        let sut = ProductRepository(urlSession: URLSessionMock(result: .success((productsData, response))))

        await #expect(throws: ProductRepository.Error.productNotFound) {
            try await sut.loadProduct(handle: "missing")
        }
    }

    @Test func loadProduct_success() async throws {
        let response = HTTPURLResponse.make(statusCode: 200)
        let sut = ProductRepository(urlSession: URLSessionMock(result: .success((productsData, response))))

        let result = try await sut.loadProduct(handle: "p1")

        #expect(result == expectedProducts[0])
    }
}

final class URLSessionMock: URLSessionProtocol {
    private(set) var invocations: [URL] = []
    private let result: Result<(Data, URLResponse), Error>

    init(result: Result<(Data, URLResponse), Error>) {
        self.result = result
    }

    func data(from url: URL) async throws -> (Data, URLResponse) {
        invocations.append(url)
        return try result.get()
    }
}

extension HTTPURLResponse {
    static func make(statusCode: Int) -> Self {
        Self(
            url: URL(string: "https://example.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }
}

private let productsData: Data = {
    let json = """
        [
          {
            "handle": "p1",
            "title": "Hat",
            "description": "Warm",
            "priceRange": { "maxVariantPrice": { "amount": "10.0" } },
            "images": [{ "url": "https://example.com/hat.png" }]
          }
        ]
        """
    return Data(json.utf8)
}()

private let expectedProducts = [Product(
    handle: "p1",
    title: "Hat",
    description: "Warm",
    imageURL: URL(string: "https://example.com/hat.png")!,
    price: 10
)]
