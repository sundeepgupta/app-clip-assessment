import SwiftUI

struct ContentView: View {
    var body: some View {
        ProductListScreen(productRepository: ProductRepository())
    }
}
