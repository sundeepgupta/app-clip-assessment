import Observation
import SwiftUI

@Observable final class QuantityStepperController {
    private(set) var quantity: Int {
        didSet {
            quantityBinding.wrappedValue = quantity
        }
    }

    private let minimum = 1
    private let maximum = 999
    private let quantityBinding: Binding<Int>

    init(quantityBinding: Binding<Int>) {
        // TODO: Consider input validation if shared later
        self.quantityBinding = quantityBinding
        self.quantity = quantityBinding.wrappedValue
    }

    var canIncrement: Bool { quantity < maximum }
    var canDecrement: Bool { quantity > minimum }

    func increment() {
        guard canIncrement else { return }
        quantity += 1
    }

    func decrement() {
        guard canDecrement else { return }
        quantity -= 1
    }
}
