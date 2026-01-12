import SwiftUI

struct ContentView: View {
    var body: some View {
        ProductListScreen(productRepository: Shared.productRepository, cartRepository: Shared.cartRepository)
    }
}

enum Shared {
    static let productRepository: ProductRepositoryProtocol = ProductRepository()
    static let cartRepository: CartRepository = CartRepository()
}
