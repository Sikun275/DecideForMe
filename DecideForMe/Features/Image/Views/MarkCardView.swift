import SwiftUI

struct MarkCardView: View {
    let mark: ImageMark
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.red : Color.orange)
                        .frame(width: 40, height: 40)
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                    
                    Text("\(mark.numericId)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Text(mark.displayName)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 90, height: 80)
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.red.opacity(0.1) : Color.orange.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.red : Color.orange, lineWidth: isSelected ? 2 : 1)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MarkCardView(
        mark: ImageMark(numericId: 1, position: CGPoint(x: 100, y: 100)),
        isSelected: false,
        onTap: {}
    )
}
