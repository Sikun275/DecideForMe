import SwiftUI

// MARK: - Primary Button Style
struct PrimaryButtonStyle: ButtonStyle {
    var isEnabled: Bool = true
    var size: ButtonSize = .medium
    
    enum ButtonSize {
        case small, medium, large
        
        var horizontalPadding: CGFloat {
            switch self {
            case .small: return AppTheme.Spacing.lg
            case .medium: return AppTheme.Spacing.xl
            case .large: return AppTheme.Spacing.xxl
            }
        }
        
        var verticalPadding: CGFloat {
            switch self {
            case .small: return AppTheme.Spacing.sm
            case .medium: return AppTheme.Spacing.md
            case .large: return AppTheme.Spacing.lg
            }
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(AppTheme.Colors.textOnPrimary)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .background(
                isEnabled ? 
                AnyShapeStyle(AppTheme.primaryGradient) : 
                AnyShapeStyle(AppTheme.Colors.primarySelected)
            )
            .cornerRadius(AppTheme.CornerRadius.large)
            .shadow(
                color: AppTheme.Shadows.large.color,
                radius: AppTheme.Shadows.large.radius,
                x: AppTheme.Shadows.large.x,
                y: AppTheme.Shadows.large.y
            )
            .scaleEffect(configuration.isPressed ? 0.95 : (isEnabled ? 1.0 : 0.95))
            .animation(AppTheme.Animations.easeInOut, value: configuration.isPressed)
            .animation(AppTheme.Animations.easeInOut, value: isEnabled)
    }
}

// MARK: - Secondary Button Style
struct SecondaryButtonStyle: ButtonStyle {
    var color: Color = AppTheme.Colors.secondary
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(color)
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(color.opacity(0.1))
            .cornerRadius(AppTheme.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(AppTheme.Animations.spring, value: configuration.isPressed)
    }
}

// MARK: - Tag Button Style
struct TagButtonStyle: ButtonStyle {
    var isSelected: Bool
    var color: Color = AppTheme.Colors.primary
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(isSelected ? AppTheme.Colors.textOnPrimary : AppTheme.Colors.textPrimary)
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, 6)
            .background(isSelected ? color : AppTheme.Colors.backgroundSecondary)
            .cornerRadius(AppTheme.CornerRadius.tag)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.tag)
                    .stroke(color, lineWidth: isSelected ? 0 : 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : (isSelected ? 1.05 : 1.0))
            .animation(AppTheme.Animations.spring, value: configuration.isPressed)
            .animation(AppTheme.Animations.spring, value: isSelected)
    }
}

// MARK: - Feature Button Style
struct FeatureButtonStyle: ButtonStyle {
    var isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.xlarge)
                    .fill(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.background)
                    .shadow(
                        color: isSelected ? AppTheme.Shadows.xlarge.color : AppTheme.Shadows.small.color,
                        radius: isSelected ? AppTheme.Shadows.xlarge.radius : AppTheme.Shadows.small.radius,
                        x: 0,
                        y: isSelected ? AppTheme.Shadows.xlarge.y : AppTheme.Shadows.small.y
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.xlarge)
                    .stroke(AppTheme.Colors.primary, lineWidth: isSelected ? 0 : 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : (isSelected ? 1.05 : 1.0))
            .animation(AppTheme.Animations.spring, value: configuration.isPressed)
            .animation(AppTheme.Animations.spring, value: isSelected)
    }
}

// MARK: - Mark Card Button Style
struct MarkCardButtonStyle: ButtonStyle {
    var isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(isSelected ? AppTheme.Colors.secondaryLight : AppTheme.Colors.primaryLight)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .stroke(isSelected ? AppTheme.Colors.secondary : AppTheme.Colors.primary, lineWidth: isSelected ? 2 : 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : (isSelected ? 1.05 : 1.0))
            .animation(AppTheme.Animations.spring, value: configuration.isPressed)
            .animation(AppTheme.Animations.spring, value: isSelected)
    }
}

