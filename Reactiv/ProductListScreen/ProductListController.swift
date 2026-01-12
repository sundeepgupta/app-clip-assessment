import Foundation
import Observation

@Observable final class ProductListController {
    enum State {
        case loading
        case failure(Error)
        case success([Product])
    }

    var state: State = .loading

    private let productRepository: ProductRepositoryProtocol

    init(productRepository: ProductRepositoryProtocol) {
        self.productRepository = productRepository
    }

    func loadData() async {
        state = .loading
        do {
            let products = try await productRepository.loadProducts()
            state = .success(products)
        } catch {
            state = .failure(error)
        }
    }
}
