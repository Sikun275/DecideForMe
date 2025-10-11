import SwiftUI

struct PlaceDetailPreviewView: View {
    let place: Place
    let viewModel: MapDecisionViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingMap = false
    @State private var placeDetail: PlaceDetail?
    @State private var isLoadingDetails = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with place info
                    VStack(spacing: 16) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        
                        Text(place.name)
                            .font(.title.bold())
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        
                        // Basic stats
                        HStack(spacing: 24) {
                            VStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                                Text(String(format: "%.1f", place.rating))
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text("Rating")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(spacing: 4) {
                                Image(systemName: "location")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                Text(String(format: "%.2f km", place.distance / 1000))
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text("Distance")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(spacing: 4) {
                                Image(systemName: "hand.thumbsup.fill")
                                    .font(.title2)
                                    .foregroundColor(.green)
                                Text("\(place.weight)")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text("Weight")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(24)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(20)
                    
                    // Action buttons
                    HStack(spacing: 16) {
                        Button(action: { showingMap = true }) {
                            HStack(spacing: 8) {
                                Image(systemName: "map")
                                    .font(.title3)
                                Text("View on Map")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        
                        Button(action: loadPlaceDetails) {
                            HStack(spacing: 8) {
                                if isLoadingDetails {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .foregroundColor(.white)
                                } else {
                                    Image(systemName: "info.circle")
                                        .font(.title3)
                                }
                                Text("More Details")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(Color.orange)
                            .cornerRadius(12)
                        }
                        .disabled(isLoadingDetails)
                    }
                    
                    // Detailed information (if loaded)
                    if let detail = placeDetail {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Additional Information")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            if let address = detail.formattedAddress {
                                InfoRow(icon: "location.fill", title: "Address", value: address)
                            }
                            
                            if let phone = detail.formattedPhoneNumber {
                                InfoRow(icon: "phone.fill", title: "Phone", value: phone)
                            }
                            
                            if let website = detail.website {
                                InfoRow(icon: "globe", title: "Website", value: website)
                            }
                            
                            if let openingHours = detail.openingHours?.weekdayText {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "clock.fill")
                                            .foregroundColor(.orange)
                                        Text("Opening Hours")
                                            .font(.subheadline.bold())
                                            .foregroundColor(.black)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        ForEach(openingHours, id: \.self) { hour in
                                            Text(hour)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                            
                            if let types = detail.types {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "tag.fill")
                                            .foregroundColor(.orange)
                                        Text("Categories")
                                            .font(.subheadline.bold())
                                            .foregroundColor(.black)
                                    }
                                    
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                        ForEach(types, id: \.self) { type in
                                            Text(type.replacingOccurrences(of: "_", with: " ").capitalized)
                                                .font(.caption)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Color.orange)
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(16)
                    }
                    
                    // Decision hint
                    VStack(spacing: 12) {
                        Text("💡 Decision Tip")
                            .font(.headline)
                            .foregroundColor(.orange)
                        
                        Text("This place has a combined score of \(String(format: "%.2f", place.combinedScore())) based on distance and your preferences.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Text("Higher scores have better chances of being selected!")
                            .font(.caption)
                            .foregroundColor(.orange)
                            .fontWeight(.medium)
                    }
                    .padding(20)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(16)
                }
                .padding()
            }
            .navigationTitle("Place Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
            }
        }
        .sheet(isPresented: $showingMap) {
            NearbyMapViewContainer(
                lat: place.lat, 
                lng: place.lng, 
                apiKey: Bundle.main.infoDictionary?["GOOGLE_PLACES_API_KEY"] as? String ?? ""
            )
        }
    }
    
    private func loadPlaceDetails() {
        guard placeDetail == nil else { return }
        
        isLoadingDetails = true
        
        viewModel.fetchPlaceDetails(placeId: place.placeId) { detail in
            DispatchQueue.main.async {
                self.placeDetail = detail
                self.isLoadingDetails = false
            }
        }
    }
}

// MARK: - Info Row Component
struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.orange)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
    }
}

#Preview {
    PlaceDetailPreviewView(
        place: Place(name: "Sample Restaurant", distance: 1500, rating: 4.5, lat: 37.7749, lng: -122.4194, placeId: "sample_place_id"),
        viewModel: MapDecisionViewModel()
    )
}
