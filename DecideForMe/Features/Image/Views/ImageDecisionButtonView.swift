import SwiftUI

struct ImageDecisionButtonView: View {
    @ObservedObject var vm: ImageMarkViewModel
    
    var body: some View {
        if let selectedMark = vm.selectedMark {
            MarkDecisionView(selectedMark: selectedMark) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    vm.clearSelection()
                }
            }
        } else {
            Button(action: selectRandomMark) {
                HStack(spacing: 8) {
                    Image(systemName: "dice.fill")
                        .font(.title3)
                    Text("Select Random Mark")
                        .font(.title3.bold())
                }
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    vm.marks.isEmpty ? 
                    AnyShapeStyle(Color.orange.opacity(0.4)) : 
                    AnyShapeStyle(LinearGradient(colors: [Color.orange, Color.orange.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                )
                .cornerRadius(16)
                .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .disabled(vm.marks.isEmpty)
            .scaleEffect(vm.marks.isEmpty ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: vm.marks.isEmpty)
        }
    }
    
    private func selectRandomMark() {
        vm.selectRandomMark()
        
        if vm.selectedMark != nil {
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.success)
        }
    }
}

#Preview {
    ImageDecisionButtonView(vm: ImageMarkViewModel())
}
