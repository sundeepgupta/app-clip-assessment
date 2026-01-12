import SwiftUI

struct CartScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var controller: CartController

    init(cartRepository: CartRepository) {
        self.controller = .init(cartRepository: cartRepository)
    }

    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 0) {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach($controller.entries) { $entry in
                                CartEntryRow(entry: $entry, onRemove: {
                                    controller.remove(handle: entry.product.handle)
                                })
                            }
                        }
                        .padding()
                    }
                }

                Divider()

                HStack {
                    Text("Total")
                    Spacer()
                    Text(controller.total, format: .currency(code: "CAD"))
                }
                .font(.title)
                .padding()
                .background(.secondary.opacity(0.1))
            }
            .overlay {
                if controller.entries.isEmpty {
                    ContentUnavailableView("Cart is empty", systemImage: "cart")
                }
            }
            .navigationTitle("Cart")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }, label: { Image(systemName: "xmark") })
                }
            }
        }
    }
}

extension CartEntry: Identifiable {
    var id: String { product.handle }
}

#Preview {
    CartScreen(cartRepository: CartRepository())
}
