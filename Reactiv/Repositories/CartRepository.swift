final class CartRepository {
    private(set) var entries: [CartEntry] = []

    func update(newEntries: [CartEntry]) {
        entries = newEntries
    }

    func add(product: Product) {
        guard !entries.contains(where: { $0.product.handle == product.handle }) else {
            return print("TODO: Handle duplicate adds")
        }
        
        entries.append(.init(product: product, quantity: 1))
    }
}
