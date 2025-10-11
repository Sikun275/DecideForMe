import SwiftUI

struct MarkView: View {
    let mark: ImageMark
    let isSelected: Bool
    let imageSize: CGSize
    let displaySize: CGSize
    let onTap: () -> Void
    
    private var scaledPosition: CGPoint {
        guard imageSize.width > 0 && imageSize.height > 0,
              displaySize.width > 0 && displaySize.height > 0 else {
            return mark.position
        }
        
        // Calculate the scale factors for display
        let scaleX = displaySize.width / imageSize.width
        let scaleY = displaySize.height / imageSize.height
        
        // Convert image coordinates to display coordinates
        return CGPoint(
            x: mark.position.x * scaleX,
            y: mark.position.y * scaleY
        )
    }
    
    private var markSize: CGFloat {
        // Scale the mark size based on the display scale
        let baseSize: CGFloat = 32
        let scale = min(displaySize.width / imageSize.width, displaySize.height / imageSize.height)
        return max(baseSize * scale, 20) // Minimum size of 20
    }
    
    private var fontSize: CGFloat {
        // Scale the font size based on the display scale
        let baseSize: CGFloat = 14
        let scale = min(displaySize.width / imageSize.width, displaySize.height / imageSize.height)
        return max(baseSize * scale, 10) // Minimum size of 10
    }
    
    var body: some View {
        VStack(spacing: 2) {
            ZStack {
                Circle()
                    .fill(isSelected ? Color.red : Color.orange)
                    .frame(width: markSize, height: markSize)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                
                Text("\(mark.numericId)")
                    .font(.system(size: fontSize, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            Text(mark.displayName)
                .font(.system(size: max(fontSize - 4, 8), weight: .medium))
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.white.opacity(0.9))
                .foregroundColor(.black)
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .position(scaledPosition)
        .onTapGesture(perform: onTap)
        .scaleEffect(isSelected ? 1.2 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    MarkView(
        mark: ImageMark(numericId: 1, position: CGPoint(x: 100, y: 100)),
        isSelected: false,
        imageSize: CGSize(width: 400, height: 300),
        displaySize: CGSize(width: 300, height: 225),
        onTap: {}
    )
}
