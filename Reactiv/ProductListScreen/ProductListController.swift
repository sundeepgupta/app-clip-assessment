import Foundation
import Observation

@Observable final class ProductListController {
    enum State {
        case loading
        case failure(Error)
        case success([Product])
    }

    var state: State = .loading
    var isShowingCart = false
    var navigationPath: [String] = []

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

    func showCart() {
        isShowingCart = true
    }

    func route(userActivity: NSUserActivity) {
        guard
            let url = userActivity.webpageURL,
            let handle = url.handle
        else { return }

        navigationPath.append(handle) // TODO: Deal with multiple stacked invocations
    }
}

extension URL {
    var handle: String? {
        guard
            pathComponents.count > 2,
            pathComponents[1] == "product",
            !pathComponents[2].isEmpty
        else { return nil }

        return pathComponents[2]
    }
}
