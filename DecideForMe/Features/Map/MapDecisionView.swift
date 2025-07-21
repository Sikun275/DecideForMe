import SwiftUI

struct MapDecisionView: View {
    @StateObject var vm = MapDecisionViewModel()
    @State private var minRatingInput = ""
    @State private var maxDistanceInput = ""
    @State private var showMap = false
   
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                // Removed custom back button
            }
            .padding(.top)
            HStack {
                TextField("Search for a place", text: $vm.keyword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Search") { vm.search() }
            }
            HStack {
                Text("Min Rating")
                TextField("0-5", text: $minRatingInput)
                    .keyboardType(.decimalPad)
                    .frame(width: 60)
                Button("Set") {
                    if let val = Double(minRatingInput), val >= 0, val <= 5 { vm.minRating = val }
                }
                Text(String(format: "%.1f", vm.minRating))
            }
            HStack {
                Text("Max Distance (km)")
                TextField("0.1-50", text: $maxDistanceInput)
                    .keyboardType(.decimalPad)
                    .frame(width: 80)
                Button("Set") {
                    if let val = Double(maxDistanceInput), val >= 0.1, val <= 50 { vm.maxDistance = val * 1000 }
                }
                Text(String(format: "%.1f", vm.maxDistance / 1000))
            }
            List(vm.filtered) { place in
                HStack {
                    NavigationLink(destination: PlaceDetailView(place: place)) {
                        VStack(alignment: .leading) {
                            Text(place.name).font(.headline)
                            HStack {
                                Text(String(format: "%.2f km", place.distance / 1000))
                                Text("⭐️ \(String(format: "%.1f", place.rating))")
                            }.font(.caption)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                    Button("✕") {
                        vm.removePlace(place)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .foregroundColor(.red)
                }
            }
            .frame(maxHeight: 400)
            Button("Decide") { vm.decide() }
                .disabled(vm.filtered.isEmpty)
            if let place = vm.selectedPlace {
                VStack {
                    Text("Chosen: \(place.name)").font(.title2)
                    Text(String(format: "%.2f km, ⭐️ %.1f", place.distance / 1000, place.rating))
                        .font(.caption)
                    HStack {
                        Button("👍") { vm.feedback(liked: true) }
                        Button("👎") { vm.feedback(liked: false) }
                    }
                    Button("Show on Map") {
                        showMap = true
                    }
                }
                .sheet(isPresented: $showMap) {
                    NearbyMapViewContainer(lat: place.lat, lng: place.lng, apiKey: Bundle.main.infoDictionary?["GOOGLE_PLACES_API_KEY"] as? String ?? "")
                }
            }
            Spacer()
        }
        .navigationTitle("Map Decision")
        .padding()
    }
}

#Preview {
    MapDecisionView()
} 
