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
}

final class ProductRepositoryMock: ProductRepositoryProtocol {
    private let result: Result<[Product], Error>

    init(result: Result<[Product], Error>) {
        self.result = result
    }

    func loadProducts() async throws -> [Product] {
        try result.get()
    }
}
