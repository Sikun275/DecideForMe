import SwiftUI

struct MapDecisionButtonView: View {
    @ObservedObject var viewModel: MapDecisionViewModel
    let onDecision: () -> Void
    
    var body: some View {
        Button(action: onDecision) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: "dice.fill")
                    .font(.title3)
                Text("Choose for Me!")
                    .font(.title3.bold())
            }
        }
        .primaryButton(isEnabled: !viewModel.filtered.isEmpty, size: .large)
    }
}

#Preview {
    MapDecisionButtonView(
        viewModel: MapDecisionViewModel(),
        onDecision: {}
    )
}
