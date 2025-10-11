import SwiftUI

struct ImageSelectionView: View {
    @ObservedObject var vm: ImageMarkViewModel
    @Binding var showingSourceActionSheet: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: { showingSourceActionSheet = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 16, weight: .medium))
                    Text("Select Image")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(colors: [Color.orange, Color.orange.opacity(0.8)], startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(12)
                .shadow(color: .orange.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            
            if !vm.marks.isEmpty {
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        vm.clearAllMarks()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "trash")
                            .font(.system(size: 14, weight: .medium))
                        Text("Clear All")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.red)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                    )
                }
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
