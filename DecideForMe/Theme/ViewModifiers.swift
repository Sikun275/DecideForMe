import SwiftUI

extension View {
    // MARK: - Card Styling
    func cardStyle(cornerRadius: CGFloat = AppTheme.CornerRadius.large) -> some View {
        self
            .background(AppTheme.Colors.background)
            .cornerRadius(cornerRadius)
            .shadow(
                color: AppTheme.Shadows.small.color,
                radius: AppTheme.Shadows.small.radius,
                x: AppTheme.Shadows.small.x,
                y: AppTheme.Shadows.small.y
            )
    }
    
    // MARK: - Button Modifiers
    func primaryButton(isEnabled: Bool = true, size: PrimaryButtonStyle.ButtonSize = .medium) -> some View {
        self.buttonStyle(PrimaryButtonStyle(isEnabled: isEnabled, size: size))
    }
    
    func secondaryButton(color: Color = AppTheme.Colors.secondary) -> some View {
        self.buttonStyle(SecondaryButtonStyle(color: color))
    }
    
    func tagButton(isSelected: Bool, color: Color = AppTheme.Colors.primary) -> some View {
        self.buttonStyle(TagButtonStyle(isSelected: isSelected, color: color))
    }
    
    func featureButton(isSelected: Bool) -> some View {
        self.buttonStyle(FeatureButtonStyle(isSelected: isSelected))
    }
    
    func markCardButton(isSelected: Bool) -> some View {
        self.buttonStyle(MarkCardButtonStyle(isSelected: isSelected))
    }
    
    // MARK: - Shadow Helpers
    func applyShadow(_ shadow: AppTheme.Shadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}

