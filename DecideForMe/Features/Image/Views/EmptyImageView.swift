import SwiftUI

struct EmptyImageView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No image selected")
                .font(.headline)
                .foregroundColor(.gray)
            
            Text("Select an image from your library or take a photo to start marking")
                .font(.caption)
                .foregroundColor(.gray.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(16)
    }
}

#Preview {
    EmptyImageView()
}
