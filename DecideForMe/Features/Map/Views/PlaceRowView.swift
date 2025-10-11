import SwiftUI

struct PlaceRowView: View {
    let place: Place
    let viewModel: MapDecisionViewModel
    let onDelete: () -> Void
    @State private var showingDetailPreview = false
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(place.name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text(String(format: "%.2f km", place.distance / 1000))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text(String(format: "%.1f", place.rating))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text("\(place.weight)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: { showingDetailPreview = true }) {
                    Image(systemName: "info.circle.fill")
                        .font(.title3)
                        .foregroundColor(.blue.opacity(0.7))
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: onDelete) {
                    Image(systemName: "trash.circle.fill")
                        .font(.title3)
                        .foregroundColor(.red.opacity(0.7))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(16)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .sheet(isPresented: $showingDetailPreview) {
            PlaceDetailPreviewView(place: place, viewModel: viewModel)
        }
    }
}

#Preview {
    PlaceRowView(
        place: Place(name: "Sample Restaurant", distance: 1500, rating: 4.5, lat: 37.7749, lng: -122.4194, placeId: "sample_place_id"),
        viewModel: MapDecisionViewModel(),
        onDelete: {}
    )
}
