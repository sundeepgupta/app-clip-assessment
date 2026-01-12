import SwiftUI

struct ProductDetailScreen: View {
    @State private var controller: ProductDetailController

    init(
        handle: String,
        productRepository: ProductRepositoryProtocol
    ) {
        self.controller = .init(
            handle: handle,
            productRepository: productRepository
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    Color.secondary.opacity(0.1)
                    AsyncImage(url: controller.product?.imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            Image(systemName: "photo") // TODO: Log
                        }
                    }
                }
                .aspectRatio(1, contentMode: .fit)

                Text(controller.product?.title ?? "")
                    .font(.title)

                Text(controller.product?.price ?? Float(0), format: .currency(code: "CAD"))
                    .font(.title2)

                Text(controller.product?.description ?? "")

                Spacer()
                Button("Add To Cart", action: controller.addToCart)
                    .buttonStyle(.borderedProminent)
                    .font(.title2)
                    .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .task(controller.loadData)
    }
}

#Preview {
    ProductDetailScreen(handle: "", productRepository: ProductRepository())
}
