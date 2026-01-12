import Foundation
import Observation

@Observable final class ProductDetailController {
    var product: Product?

    private let productRepository: ProductRepositoryProtocol
    private let handle: String

    init(
        handle: String,
        productRepository: ProductRepositoryProtocol
    ) {
        self.handle = handle
        self.productRepository = productRepository
    }

    func loadData() async {
        do {
            product = try await productRepository.loadProduct(handle: handle)
        } catch {
            print("TODO: Handle error:", error.localizedDescription)
        }
    }

    func addToCart() {}
}
