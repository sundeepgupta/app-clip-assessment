import SwiftUI

struct CartEntryRow: View {
    @Binding var entry: CartEntry
    let onRemove: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ProductAsyncImage(url: entry.product.imageURL)
                .containerRelativeFrame(.horizontal, count: 4, spacing: 0)

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Text(entry.product.title)
                        .font(.headline)

                    Spacer()
                    Button(role: .destructive, action: onRemove) { Image(systemName: "trash") }
                }

                Text(entry.product.price, format: .currency(code: "CAD"))
                    .font(.subheadline)

                HStack(spacing: 12) {
                    QuantityStepper(quantity: $entry.quantity)

                    Spacer(minLength: 8)
                    Text(entry.amount, format: .currency(code: "CAD"))
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    CartEntryRowPreview()
}

private struct CartEntryRowPreview: View {
    @State private var entry = CartEntry(
        product: Product(
            handle: "reactiv-hoodie",
            title: "Reactiv Hoodie",
            description: "",
            imageURL: URL(string: "https://cdn.shopify.com/s/files/1/0654/2458/8973/files/107112-hoodie-mockup_1180x400.png.jpg?v=1719328890")!,
            price: 50.0
        ),
        quantity: 2
    )

    var body: some View {
        CartEntryRow(entry: $entry, onRemove: {})
            .padding()
    }
}
