import SwiftUI

struct AppTheme {
    // MARK: - Colors
    struct Colors {
        static let primary = Color.orange
        static let primaryDark = Color.orange.opacity(0.8)
        static let primaryLight = Color.orange.opacity(0.1)
        static let primarySelected = Color.orange.opacity(0.4)
        
        static let secondary = Color.red
        static let secondaryLight = Color.red.opacity(0.1)
        
        static let textPrimary = Color.black
        static let textSecondary = Color.gray
        static let textTertiary = Color.gray.opacity(0.7)
        static let textOnPrimary = Color.white
        
        static let background = Color.white
        static let backgroundSecondary = Color.gray.opacity(0.1)
        static let backgroundGradient = LinearGradient(
            gradient: Gradient(colors: [Color.white, Color.orange.opacity(0.1)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 32
        static let xxxl: CGFloat = 40
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xlarge: CGFloat = 20
        static let tag: CGFloat = 16
    }
    
    // MARK: - Shadows
    struct Shadows {
        static let small = Shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        static let medium = Shadow(color: .orange.opacity(0.3), radius: 4, x: 0, y: 2)
        static let large = Shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
        static let xlarge = Shadow(color: .orange.opacity(0.4), radius: 8, x: 0, y: 4)
        static let logo = Shadow(color: .orange.opacity(0.3), radius: 10, x: 0, y: 5)
        static let mark = Shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
        static let markSelected = Shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
    }
    
    struct Shadow {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }
    
    // MARK: - Gradients
    static let primaryGradient = LinearGradient(
        colors: [Colors.primary, Colors.primaryDark],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // MARK: - Animations
    struct Animations {
        static let spring = Animation.spring(response: 0.3, dampingFraction: 0.7)
        static let springSlow = Animation.spring(response: 0.6, dampingFraction: 0.8)
        static let easeInOut = Animation.easeInOut(duration: 0.2)
    }
    
    // MARK: - Fonts
    struct Fonts {
        static let title = Font.system(size: 32, weight: .bold, design: .rounded)
        static let subtitle = Font.system(size: 16, weight: .medium, design: .rounded)
        static let headline = Font.system(size: 18, weight: .bold, design: .rounded)
        static let body = Font.system(size: 14, weight: .medium, design: .rounded)
        static let caption = Font.system(size: 12, weight: .medium, design: .rounded)
    }
}

