import Foundation
@testable import Reactiv
import Testing

struct ProductListControllerTests {
    @Test func loadData_failure() async {
        let sut = ProductListController(
            productRepository: ProductRepositoryMock(result: .failure(TestError()))
        )

        await sut.loadData()

        guard case let .failure(error) = sut.state else { Issue.record(); return }
        #expect(error is TestError)
    }

    @Test func loadData_success() async {
        let products = [Product(
            handle: "p1",
            title: "Hat",
            description: "Warm",
            imageURL: URL(string: "https://example.com/hat.png")!,
            price: 10
        )]
        let sut = ProductListController(
            productRepository: ProductRepositoryMock(result: .success(products))
        )

        await sut.loadData()

        guard case let .success(result) = sut.state else { Issue.record(); return }
        #expect(result == products)
    }

    @Test(
        arguments: [
            (
                type: "wrong",
                url: nil,
                navigationPath: []
            ),
            (
                type: NSUserActivityTypeBrowsingWeb,
                url: nil,
                navigationPath: []
            ),
            (
                type: NSUserActivityTypeBrowsingWeb,
                url: URL(string: "http://example.com/product/abc")!,
                navigationPath: ["abc"]
            ),
        ]
    )
    func routeUserActivity(params: (type: String, url: URL?, navigationPath: [String])) {
        let sut = ProductListController(
            productRepository: ProductRepositoryMock(result: .failure(TestError()))
        )
        #expect(sut.navigationPath.isEmpty)

        let userActivity = NSUserActivity(activityType: params.type)
        userActivity.webpageURL = params.url
        sut.route(userActivity: userActivity)

        #expect(sut.navigationPath == params.navigationPath)
    }
}

struct URLParsingTests {
    @Test(
        arguments: [
            (url: URL(string: "https://example.com/product/hat")!, expected: "hat"),
            (url: URL(string: "https://example.com/product/hat/")!, expected: "hat"),
            (url: URL(string: "https://example.com/product/hat?color=red")!, expected: "hat"),
            (url: URL(string: "https://example.com/product/hat#details")!, expected: "hat"),
            (url: URL(string: "https://example.com/product/hat/extra")!, expected: "hat"),
            (url: URL(string: "https://example.com/product")!, expected: nil),
            (url: URL(string: "https://example.com/product/")!, expected: nil),
            (url: URL(string: "https://example.com/products/hat")!, expected: nil),
            (url: URL(string: "https://example.com/")!, expected: nil),
            (url: URL(string: "https://example.com/collections/all")!, expected: nil),
        ]
    )
    func url_handle(params: (url: URL, expected: String?)) {
        #expect(params.url.handle == params.expected)
    }
}

final class ProductRepositoryMock: ProductRepositoryProtocol {
    private let result: Result<[Product], Error>

    init(result: Result<[Product], Error>) {
        self.result = result
    }

    func loadProducts() async throws -> [Product] {
        try result.get()
    }

    func loadProduct(handle: String) async throws -> Product {
        Product(
            handle: "p1",
            title: "Hat",
            description: "Warm",
            imageURL: URL(string: "https://example.com/hat.png")!,
            price: 10
        )
    }
}

struct TestError: Error {}
