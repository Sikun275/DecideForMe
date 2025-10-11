import SwiftUI

struct ImageHeaderView: View {
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "photo")
                    .font(.title2)
                    .foregroundColor(.orange)
                Text("Visual Decisions")
                    .font(.title2.bold())
                    .foregroundColor(.black)
                Spacer()
            }
            
            Text("Mark your image and let us choose for you")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    ImageHeaderView()
}
