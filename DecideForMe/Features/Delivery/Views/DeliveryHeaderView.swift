import SwiftUI

struct DeliveryHeaderView: View {
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "fork.knife")
                    .font(.title2)
                    .foregroundColor(.orange)
                Text("Food & Delivery")
                    .font(.title2.bold())
                    .foregroundColor(.black)
                Spacer()
            }
            
            Text("Add your options and let us decide for you")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}

#Preview {
    DeliveryHeaderView()
}
