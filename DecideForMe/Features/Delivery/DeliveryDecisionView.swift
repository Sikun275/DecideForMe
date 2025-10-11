import SwiftUI

struct DeliveryDecisionView: View {
    @StateObject var vm = OptionViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var newName = ""
    @State private var newTags = ""
    @State private var showFeedback = false
    @State private var lastDecision: Option?
    @State private var isAddingOption = false
    @State private var showConfetti = false
    
    var body: some View {
        ZStack {
            // Background
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                DeliveryHeaderView()
                
                // Add Option Section
                AddOptionView(
                    vm: vm,
                    newName: $newName,
                    newTags: $newTags,
                    onAdd: addOption
                )
                
                // Tags Filter
                TagsFilterView(vm: vm)
                
                // Options List
                OptionsListView(vm: vm)
                
                Spacer()
                
                // Decision Section
                DeliveryDecisionResultView(
                    vm: vm,
                    showFeedback: $showFeedback,
                    onDecision: makeDecision,
                    onFeedback: { liked in
                        vm.feedback(liked: liked)
                        showFeedback = false
                        withAnimation(.easeInOut(duration: 0.5)) {
                            vm.selectedOption = nil
                        }
                    }
                )
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.orange)
                }
            }
        }
    }
    
    private func addOption() {
        guard !newName.isEmpty else { return }
        
        let tags = newTags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        vm.addOption(name: newName, tags: tags)
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            newName = ""
            newTags = ""
        }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func makeDecision() {
        vm.decide()
        lastDecision = vm.selectedOption
        
        if vm.selectedOption != nil {
            showFeedback = true
            
            // Haptic feedback
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.success)
        }
    }
}

#Preview {
    NavigationView {
        DeliveryDecisionView()
    }
} 