import SwiftUI

struct ProductListCard: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading) {
            ProductAsyncImage(url: product.imageURL)

            Text(product.title)
                .font(.headline)
                .lineLimit(1)

            Text(product.price, format: .currency(code: "CAD"))
                .font(.subheadline)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    VStack {
        HStack {
            ProductListCard(
                product: .init(handle: "", title: "Test Product Card", description: "Soft comfort for every day with a structured fit, smooth seams, and breathable fabric. Built to wear well on repeat, with a relaxed drape and a clean finish for daily rotation.", imageURL: URL(string: "https://error.com")!,
                               price: 42.99
                              )
            )
            ProductListCard(
                product: .init(handle: "", title: "Test Product Card", description: "Soft comfort for every day with a structured fit, smooth seams, and breathable fabric. Built to wear well on repeat, with a relaxed drape and a clean finish for daily rotation.", imageURL: URL(string: "https://cdn.shopify.com/s/files/1/0654/2458/8973/files/15432182594235543675_2048_1180x400.jpg?v=1713378389")!,
                               price: 42.99
                              )
            )
        }
        HStack {
            ProductListCard(
                product: .init(handle: "", title: "Test Product CardTest Product CardTest Product Card", description: "Soft comfort for every day with a structured fit, smooth seams, and breathable fabric. Built to wear well on repeat, with a relaxed drape and a clean finish for daily rotation.", imageURL: URL(string: "https://cdn.shopify.com/s/files/1/0654/2458/8973/files/15432182594235543675_2048_1180x400.jpg?v=1713378389")!,
                               price: 42.99
                              )
            )
            ProductListCard(
                product: .init(handle: "", title: "Test Product Card", description: "Soft comfort for every day with a structured fit, smooth seams, and breathable fabric. Built to wear well on repeat, with a relaxed drape and a clean finish for daily rotation.", imageURL: URL(string: "https://cdn.shopify.com/s/files/1/0654/2458/8973/files/15432182594235543675_2048_1180x400.jpg?v=1713378389")!,
                               price: 42.99
                              )
            )
        }
    }
}

