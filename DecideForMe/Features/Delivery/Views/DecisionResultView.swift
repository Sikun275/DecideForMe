import SwiftUI

struct DecisionResultView: View {
    let option: Option
    @Binding var showFeedback: Bool
    let onFeedback: (Bool) -> Void
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            VStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(AppTheme.Colors.primary)
                
                Text("We chose for you!")
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                Text(option.name)
                    .font(.title2.bold())
                    .foregroundColor(AppTheme.Colors.primary)
                    .multilineTextAlignment(.center)
                
                if !option.tags.isEmpty {
                    Text(option.tags.joined(separator: " • "))
                        .font(AppTheme.Fonts.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(AppTheme.Spacing.xl)
            .background(AppTheme.Colors.primaryLight)
            .cornerRadius(AppTheme.CornerRadius.large)
            
            if showFeedback {
                HStack(spacing: 24) {
                    Button(action: { onFeedback(true) }) {
                        VStack(spacing: AppTheme.Spacing.xs) {
                            Image(systemName: "hand.thumbsup.fill")
                                .font(.title2)
                            Text("Good Choice")
                                .font(AppTheme.Fonts.caption)
                        }
                        .foregroundColor(.green)
                        .padding(.horizontal, AppTheme.Spacing.xl)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(AppTheme.CornerRadius.medium)
                    }
                    
                    Button(action: { onFeedback(false) }) {
                        VStack(spacing: AppTheme.Spacing.xs) {
                            Image(systemName: "hand.thumbsdown.fill")
                                .font(.title2)
                            Text("Not Great")
                                .font(AppTheme.Fonts.caption)
                        }
                        .foregroundColor(.red)
                        .padding(.horizontal, AppTheme.Spacing.xl)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(AppTheme.CornerRadius.medium)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview {
    DecisionResultView(
        option: Option(id: UUID(), name: "Pizza", tags: ["fast", "delicious"], weight: 3),
        showFeedback: .constant(true),
        onFeedback: { _ in }
    )
}
