import SwiftUI

struct ProductListScreen: View {
    @State private var controller: ProductListController
    private let productRepository: ProductRepositoryProtocol

    init(productRepository: ProductRepositoryProtocol) {
        self.controller = .init(productRepository: productRepository)
        self.productRepository = productRepository
    }

    var body: some View {
        NavigationStack {
            controller.state.view
                .navigationTitle("Our Products")
                .navigationDestination(for: String.self) { handle in
                    ProductDetailScreen(handle: handle, productRepository: productRepository)
                }
                .task(controller.loadData)
        }
    }
}

extension ProductListController.State {
    @ViewBuilder fileprivate var view: some View {
        switch self {
        case .loading:
            ProgressView()

        case let .failure(error):
            Text(String(describing: error))

        case let .success(products):
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ],
                    spacing: 16
                ) {
                    ForEach(products) { product in
                        NavigationLink(value: product.handle) {
                            ProductListCard(product: product)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

extension Product: Identifiable {
    var id: String { handle }
}

#Preview {
    ProductListScreen(productRepository: ProductRepository())
}
