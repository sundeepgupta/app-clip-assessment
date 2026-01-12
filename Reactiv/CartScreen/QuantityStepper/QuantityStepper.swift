import SwiftUI

struct QuantityStepper: View {
    @State private var controller: QuantityStepperController

    init(quantity: Binding<Int>) {
        self.controller = .init(quantityBinding: quantity)
    }

    var body: some View {
        HStack(spacing: 12) {
            Button(action: controller.decrement) { Image(systemName: "minus") }
                .disabled(!controller.canDecrement)

            Text("\(controller.quantity)")
                .monospacedDigit()
                .frame(minWidth: 24)

            Button(action: controller.increment) { Image(systemName: "plus") }
                .disabled(!controller.canIncrement)
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    QuantityStepperPreview()
}

private struct QuantityStepperPreview: View {
    @State private var quantity = 1

    var body: some View {
        QuantityStepper(quantity: $quantity)
    }
}
