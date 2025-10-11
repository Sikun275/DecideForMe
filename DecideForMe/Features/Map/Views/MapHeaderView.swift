import SwiftUI

struct MapHeaderView: View {
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "map")
                    .font(.title2)
                    .foregroundColor(.orange)
                Text("Places & Locations")
                    .font(.title2.bold())
                    .foregroundColor(.black)
                Spacer()
            }
            
            Text("Discover and decide on places to visit")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}

#Preview {
    MapHeaderView()
}
