import SwiftUI

struct DeliveryHeaderView: View {
    var body: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            HStack {
                Image(systemName: "fork.knife")
                    .font(.title2)
                    .foregroundColor(AppTheme.Colors.primary)
                Text("Food & Delivery")
                    .font(.title2.bold())
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Spacer()
            }
            
            Text("Add your options and let us decide for you")
                .font(AppTheme.Fonts.body)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .padding(.horizontal)
    }
}

#Preview {
    DeliveryHeaderView()
}
