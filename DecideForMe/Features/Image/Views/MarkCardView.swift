import SwiftUI

struct MarkCardView: View {
    let mark: ImageMark
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: AppTheme.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(isSelected ? AppTheme.Colors.secondary : AppTheme.Colors.primary)
                        .frame(width: 40, height: 40)
                        .applyShadow(isSelected ? AppTheme.Shadows.markSelected : AppTheme.Shadows.mark)
                    
                    Text("\(mark.numericId)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.Colors.textOnPrimary)
                }
                
                Text(mark.displayName)
                    .font(AppTheme.Fonts.caption)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 90, height: 80)
            .padding(AppTheme.Spacing.sm)
        }
        .markCardButton(isSelected: isSelected)
    }
}

#Preview {
    MarkCardView(
        mark: ImageMark(numericId: 1, position: CGPoint(x: 100, y: 100)),
        isSelected: false,
        onTap: {}
    )
    MarkCardView(
        mark: ImageMark(numericId: 2, position: CGPoint(x: 200, y: 200)),
        isSelected: true,
        onTap: {}
    )
}
