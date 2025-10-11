import SwiftUI

struct PlaceDecisionView: View {
    let place: Place
    @Binding var showMap: Bool
    let onFeedback: (Bool) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.orange)
                
                Text("We chose for you!")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(place.name)
                    .font(.title2.bold())
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(String(format: "%.2f km", place.distance / 1000))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(String(format: "%.1f", place.rating))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(20)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(16)
            
            HStack(spacing: 16) {
                Button(action: { onFeedback(true) }) {
                    VStack(spacing: 4) {
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.title2)
                        Text("Good Choice")
                            .font(.caption)
                    }
                    .foregroundColor(.green)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                }
                
                Button(action: { onFeedback(false) }) {
                    VStack(spacing: 4) {
                        Image(systemName: "hand.thumbsdown.fill")
                            .font(.title2)
                        Text("Not Great")
                            .font(.caption)
                    }
                    .foregroundColor(.red)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                }
                
                Button(action: { showMap = true }) {
                    VStack(spacing: 4) {
                        Image(systemName: "map")
                            .font(.title2)
                        Text("Show Map")
                            .font(.caption)
                    }
                    .foregroundColor(.blue)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    PlaceDecisionView(
        place: Place(name: "Sample Restaurant", distance: 1500, rating: 4.5, lat: 37.7749, lng: -122.4194, placeId: "sample_place_id"),
        showMap: .constant(false),
        onFeedback: { _ in }
    )
}
