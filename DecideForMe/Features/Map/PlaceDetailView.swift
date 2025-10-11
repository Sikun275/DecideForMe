import SwiftUI

struct PlaceDetailView: View {
    let place: Place
    @StateObject private var vm = MapDecisionViewModel()
    @State private var placeDetail: PlaceDetail?
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if isLoading {
                    ProgressView("Loading details...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let detail = placeDetail {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(detail.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        if let address = detail.formattedAddress {
                            HStack {
                                Image(systemName: "location")
                                Text(address)
                            }
                            .font(.subheadline)
                        }
                        
                        if let phone = detail.formattedPhoneNumber {
                            HStack {
                                Image(systemName: "phone")
                                Text(phone)
                            }
                            .font(.subheadline)
                        }
                        
                        if let website = detail.website {
                            HStack {
                                Image(systemName: "globe")
                                Link("Website", destination: URL(string: website)!)
                            }
                            .font(.subheadline)
                        }
                        
                        if let hours = detail.openingHours {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: "clock")
                                    Text(hours.openNow == true ? "Open Now" : "Closed")
                                        .foregroundColor(hours.openNow == true ? .green : .red)
                                }
                                .font(.subheadline)
                                
                                if let weekdays = hours.weekdayText {
                                    ForEach(weekdays, id: \.self) { day in
                                        Text(day)
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                        
                        if let rating = detail.rating {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", rating))
                                if let total = detail.userRatingsTotal {
                                    Text("(\(total) reviews)")
                                        .foregroundColor(.secondary)
                                }
                            }
                            .font(.subheadline)
                        }
                        
                        if let priceLevel = detail.priceLevel {
                            HStack {
                                Image(systemName: "dollarsign.circle")
                                Text(String(repeating: "$", count: priceLevel))
                            }
                            .font(.subheadline)
                        }
                        
                        if let types = detail.types {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Categories:")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text(types.joined(separator: ", "))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        if let reviews = detail.reviews, !reviews.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Recent Reviews")
                                    .font(.headline)
                                
                                ForEach(Array(reviews.prefix(3).enumerated()), id: \.offset) { _, review in
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(review.authorName)
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                            Spacer()
                                            HStack {
                                                ForEach(1...5, id: \.self) { star in
                                                    Image(systemName: star <= review.rating ? "star.fill" : "star")
                                                        .foregroundColor(.yellow)
                                                        .font(.caption2)
                                                }
                                            }
                                        }
                                        Text(review.text)
                                            .font(.caption)
                                            .lineLimit(3)
                                    }
                                    .padding(8)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding()
                } else {
                    Text("Unable to load place details")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .navigationTitle("Place Details")
        .onAppear {
            vm.fetchPlaceDetails(placeId: place.placeId) { detail in
                placeDetail = detail
                isLoading = false
            }
        }
    }
}

#Preview {
    PlaceDetailView(place: Place(name: "Test Place", distance: 1000, rating: 4.5, lat: 43.6532, lng: -79.3832, placeId: "test_id", weight: 1))
}
