import SwiftUI

struct DeliveryDecisionResultView: View {
    @ObservedObject var vm: OptionViewModel
    @Binding var showFeedback: Bool
    let onDecision: () -> Void
    let onFeedback: (Bool) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            if let option = vm.selectedOption {
                DecisionResultView(option: option, showFeedback: $showFeedback) { liked in
                    onFeedback(liked)
                }
            } else {
                Button(action: onDecision) {
                    HStack(spacing: 8) {
                        Image(systemName: "dice.fill")
                            .font(.title3)
                        Text("Decide for Me!")
                            .font(.title3.bold())
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        vm.filteredOptions.isEmpty ? 
                        AnyShapeStyle(Color.orange.opacity(0.4)) : 
                        AnyShapeStyle(LinearGradient(colors: [Color.orange, Color.orange.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                    )
                    .cornerRadius(16)
                    .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .disabled(vm.filteredOptions.isEmpty)
                .scaleEffect(vm.filteredOptions.isEmpty ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: vm.filteredOptions.isEmpty)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}

#Preview {
    DeliveryDecisionResultView(
        vm: OptionViewModel(),
        showFeedback: .constant(false),
        onDecision: {},
        onFeedback: { _ in }
    )
}
