import Foundation
@testable import Reactiv
import Testing

/// CartRepository + CartController
struct CartTests {
    @Test func cart_operations() {
        let repository = CartRepository()

        // Adding products
        let product1 = Product.make(handle: "p1", price: 2)
        repository.add(product: product1)
        #expect(repository.entries == [.init(product: product1, quantity: 1)])

        let product1Duplicate = Product.make(handle: "p1", price: 99)
        repository.add(product: product1Duplicate)
        #expect(repository.entries == [.init(product: product1, quantity: 1)])

        let product2 = Product.make(handle: "p2", price: 3)
        repository.add(product: product2)
        #expect(repository.entries == [
            .init(product: product1, quantity: 1),
            .init(product: product2, quantity: 1)
        ])

        // Controller initial state
        let controller = CartController(cartRepository: repository)
        #expect(controller.entries == [
            .init(product: product1, quantity: 1),
            .init(product: product2, quantity: 1)
        ])
        #expect(controller.total == 5)

        // Simulate quantity change which is currently done via SwiftUI
        controller.entries[1].quantity += 1
        #expect(repository.entries == [
            .init(product: product1, quantity: 1),
            .init(product: product2, quantity: 2)
        ])
        #expect(controller.entries == [
            .init(product: product1, quantity: 1),
            .init(product: product2, quantity: 2)
        ])
        #expect(controller.total == 8)

        // Removing
        controller.remove(handle: "p1")
        #expect(repository.entries == [.init(product: product2, quantity: 2)])
        #expect(controller.entries == [.init(product: product2, quantity: 2)])
        #expect(controller.total == 6)
    }
}

extension Product {
    static func make(handle: String, price: Float = 42.42) -> Self {
        .init(
            handle: handle,
            title: "\(handle) Title",
            description: "\(handle) Description",
            imageURL: URL(string: "https://example.com/\(handle).png")!,
            price: price
        )
    }
}
