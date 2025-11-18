import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 40))
                .foregroundColor(AppTheme.Colors.textTertiary)
            
            Text("No options yet")
                .font(AppTheme.Fonts.headline)
                .foregroundColor(AppTheme.Colors.textSecondary)
            
            Text("Add some options above to get started")
                .font(AppTheme.Fonts.caption)
                .foregroundColor(AppTheme.Colors.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(AppTheme.Spacing.xxxl)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    EmptyStateView()
}
