import SwiftUI

struct ProductDetailScreen: View {
    @State private var controller: ProductDetailController

    init(
        handle: String,
        productRepository: ProductRepositoryProtocol,
        cartRepository: CartRepository
    ) {
        self.controller = .init(
            handle: handle,
            productRepository: productRepository,
            cartRepository: cartRepository
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ProductAsyncImage(url: controller.product?.imageURL)

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
    ProductDetailScreen(handle: "", productRepository: ProductRepository(), cartRepository: CartRepository())
}
