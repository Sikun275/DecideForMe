import SwiftUI

struct OptionRowView: View {
    let option: Option
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(option.name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                if !option.tags.isEmpty {
                    HStack(spacing: AppTheme.Spacing.xs) {
                        ForEach(option.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.system(size: 10, weight: .medium))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(AppTheme.Colors.primary.opacity(0.2))
                                .foregroundColor(AppTheme.Colors.primary)
                                .cornerRadius(AppTheme.CornerRadius.small)
                        }
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: AppTheme.Spacing.xs) {
                Text("💪 \(option.weight)")
                    .font(AppTheme.Fonts.caption)
                    .foregroundColor(AppTheme.Colors.primary)
                
                Button(action: onDelete) {
                    Image(systemName: "trash.circle.fill")
                        .font(.title3)
                        .foregroundColor(AppTheme.Colors.secondary.opacity(0.7))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.backgroundSecondary)
        .cornerRadius(AppTheme.CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .stroke(AppTheme.Colors.textSecondary.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    OptionRowView(
        option: Option(id: UUID(), name: "Pizza", tags: ["fast", "delicious"], weight: 3),
        onDelete: {}
    )
}
