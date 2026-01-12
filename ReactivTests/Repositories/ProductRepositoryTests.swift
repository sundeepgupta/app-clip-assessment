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
        let data = Data(json.utf8)
        let response = HTTPURLResponse.make(statusCode: 399)
        let sut = ProductRepository(urlSession: URLSessionMock(result: .success((data, response))))

        let result = try await sut.loadProducts()

        let expected = [Product(
            handle: "p1",
            title: "Hat",
            description: "Warm",
            imageURL: URL(string: "https://example.com/hat.png")!,
            price: 10
        )]
        #expect(result == expected)
    }
}

final class URLSessionMock: URLSessionProtocol {
    private let result: Result<(Data, URLResponse), Error>

    init(result: Result<(Data, URLResponse), Error>) {
        self.result = result
    }

    func data(from url: URL) async throws -> (Data, URLResponse) {
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
