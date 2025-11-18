import SwiftUI

struct DeliveryDecisionButtonView: View {
    @ObservedObject var vm: OptionViewModel
    @Binding var showFeedback: Bool
    let onDecision: () -> Void
    let onFeedback: (Bool) -> Void
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            if let option = vm.selectedOption {
                DecisionResultView(option: option, showFeedback: $showFeedback) { liked in
                    onFeedback(liked)
                }
            } else {
                Button(action: onDecision) {
                    HStack(spacing: AppTheme.Spacing.sm) {
                        Image(systemName: "dice.fill")
                            .font(.title3)
                        Text("Decide for Me!")
                            .font(.title3.bold())
                    }
                }
                .primaryButton(isEnabled: !vm.filteredOptions.isEmpty, size: .large)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, AppTheme.Spacing.xl)
    }
}

#Preview {
    DeliveryDecisionButtonView(
        vm: OptionViewModel(),
        showFeedback: .constant(false),
        onDecision: {},
        onFeedback: { _ in }
    )
}
