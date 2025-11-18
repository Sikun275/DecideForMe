import SwiftUI

struct MarkDecisionView: View {
    let selectedMark: ImageMark
    let onClear: () -> Void
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.green)
                
                Text("Selected Mark")
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                Spacer()
            }
            
            HStack {
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.primary)
                        .frame(width: 50, height: 50)
                        .applyShadow(AppTheme.Shadows.mark)
                    
                    Text("\(selectedMark.numericId)")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.Colors.textOnPrimary)
                }
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(selectedMark.displayName)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    
                    Text("Position: (\(Int(selectedMark.position.x)), \(Int(selectedMark.position.y)))")
                        .font(AppTheme.Fonts.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(AppTheme.Colors.primaryLight)
            )
        }
        .padding()
        .cardStyle(cornerRadius: AppTheme.CornerRadius.large)
    }
}

#Preview {
    MarkDecisionView(
        selectedMark: ImageMark(numericId: 1, position: CGPoint(x: 100, y: 100)),
        onClear: {}
    )
}
