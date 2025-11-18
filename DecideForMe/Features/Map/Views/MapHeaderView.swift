import SwiftUI

struct MapHeaderView: View {
    var body: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            HStack {
                Image(systemName: "map")
                    .font(.title2)
                    .foregroundColor(AppTheme.Colors.primary)
                Text("Places & Locations")
                    .font(.title2.bold())
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Spacer()
            }
            
            Text("Discover and decide on places to visit")
                .font(AppTheme.Fonts.body)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .padding(.horizontal)
    }
}

#Preview {
    MapHeaderView()
}
