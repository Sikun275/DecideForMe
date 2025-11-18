import SwiftUI

struct ImageHeaderView: View {
    let hasSelectedImage: Bool
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            HStack {
                Image(systemName: "photo")
                    .font(.title2)
                    .foregroundColor(AppTheme.Colors.primary)
                Text("Visual Decisions")
                    .font(.title2.bold())
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Spacer()
            }
            
            Text(hasSelectedImage ? "Tap to start" : "Take a photo")
                .font(AppTheme.Fonts.body)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    ImageHeaderView(hasSelectedImage: false)
}
