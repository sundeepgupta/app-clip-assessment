import Foundation
import Observation

@Observable final class CartController {
    var entries: [CartEntry] {
        didSet { cartRepository.update(newEntries: entries) }
    }

    private let cartRepository: CartRepository

    init(cartRepository: CartRepository) {
        self.entries = cartRepository.entries
        self.cartRepository = cartRepository
    }

    var total: Float {
        entries.reduce(0) { $0 + $1.amount }
    }

    func remove(handle: String) {
        entries.removeAll { $0.product.handle == handle }
    }
}

extension CartEntry {
    var amount: Float { product.price * Float(quantity) }
}
