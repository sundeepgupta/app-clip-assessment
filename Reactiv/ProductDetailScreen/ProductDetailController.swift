import Foundation
import Observation

@Observable final class ProductDetailController {
    var product: Product?

    private let productRepository: ProductRepositoryProtocol
    private let cartRepository: CartRepository
    private let handle: String

    init(
        handle: String,
        productRepository: ProductRepositoryProtocol,
        cartRepository: CartRepository
    ) {
        self.handle = handle
        self.productRepository = productRepository
        self.cartRepository = cartRepository
    }

    func loadData() async {
        do {
            product = try await productRepository.loadProduct(handle: handle)
        } catch {
            print("TODO: Handle error:", error.localizedDescription)
        }
    }

    func addToCart() {
        guard let product else { return }
        cartRepository.add(product: product)
    }
}
