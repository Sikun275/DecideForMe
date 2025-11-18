import SwiftUI

struct EmptyImageView: View {
    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: "photo.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.Colors.textTertiary)
            
            Text("No image selected")
                .font(AppTheme.Fonts.headline)
                .foregroundColor(AppTheme.Colors.textSecondary)
            
            Text("Select an image from your library or take a photo to start marking")
                .font(AppTheme.Fonts.caption)
                .foregroundColor(AppTheme.Colors.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(AppTheme.Spacing.xxxl)
        .frame(maxWidth: .infinity)
        .background(AppTheme.Colors.backgroundSecondary)
        .cornerRadius(AppTheme.CornerRadius.large)
    }
}

#Preview {
    EmptyImageView()
}
