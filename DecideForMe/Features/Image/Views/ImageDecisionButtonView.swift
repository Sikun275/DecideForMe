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
                HStack(spacing: AppTheme.Spacing.sm) {
                    Image(systemName: "dice.fill")
                        .font(.title3)
                    Text("Select Random Mark")
                        .font(.title3.bold())
                }
            }
            .primaryButton(isEnabled: !vm.marks.isEmpty, size: .large)
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
