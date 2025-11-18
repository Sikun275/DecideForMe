import SwiftUI

struct ImageSelectionView: View {
    @ObservedObject var vm: ImageMarkViewModel
    @Binding var showingSourceActionSheet: Bool
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Button(action: { showingSourceActionSheet = true }) {
                HStack(spacing: AppTheme.Spacing.sm) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 16, weight: .medium))
                    Text("Select Image")
                        .font(AppTheme.Fonts.body)
                }
            }
            .primaryButton(size: .medium)
            
            if !vm.marks.isEmpty {
                Button(action: {
                    withAnimation(AppTheme.Animations.spring) {
                        vm.clearAllMarks()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "trash")
                            .font(.system(size: 14, weight: .medium))
                        Text("Clear All")
                            .font(AppTheme.Fonts.body)
                    }
                }
                .secondaryButton(color: AppTheme.Colors.secondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    ImageSelectionView(
        vm: ImageMarkViewModel(),
        showingSourceActionSheet: .constant(false)
    )
}
