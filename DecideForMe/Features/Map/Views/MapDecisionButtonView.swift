import SwiftUI

struct MapDecisionButtonView: View {
    @ObservedObject var viewModel: MapDecisionViewModel
    let onDecision: () -> Void
    
    var body: some View {
        Button(action: onDecision) {
            HStack(spacing: 8) {
                Image(systemName: "dice.fill")
                    .font(.title3)
                Text("Choose for Me!")
                    .font(.title3.bold())
            }
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(
                viewModel.filtered.isEmpty ? 
                AnyShapeStyle(Color.orange.opacity(0.4)) : 
                AnyShapeStyle(LinearGradient(colors: [Color.orange, Color.orange.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
            )
            .cornerRadius(16)
            .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .disabled(viewModel.filtered.isEmpty)
        .scaleEffect(viewModel.filtered.isEmpty ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: viewModel.filtered.isEmpty)
    }
}

#Preview {
    MapDecisionButtonView(
        viewModel: MapDecisionViewModel(),
        onDecision: {}
    )
}
