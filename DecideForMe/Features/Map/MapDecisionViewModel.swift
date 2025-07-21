import Foundation

class MapDecisionViewModel: ObservableObject {
    @Published var keyword: String = ""
    @Published var places: [Place] = []
    @Published var selectedPlace: Place?
    @Published var minRating: Double = 0
    @Published var maxDistance: Double = 5000
    
    private var apiKey: String {
        Bundle.main.infoDictionary?["GOOGLE_PLACES_API_KEY"] as? String ?? "NULL"
    }
    // Default location (latitude, longitude) - e.g., Toronto
    private let defaultLocation = (lat: 43.6532, lng: -79.3832)
    
    func search() {
        guard !keyword.isEmpty else { places = []; return }
        let radius = Int(maxDistance)
        let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(defaultLocation.lat),\(defaultLocation.lng)&radius=\(radius)&keyword=\(query)&key=\(apiKey)"
        //print("API URL: \(urlString)")
        //print("Google Places API Key: \(apiKey)")
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            print("Error: \(error?.localizedDescription ?? "none")")
            guard let data = data, error == nil else { return }
            print("Raw response: \(String(data: data, encoding: .utf8)?.prefix(500) ?? "")")
            do {
                let decoded = try JSONDecoder().decode(GPlacesResponse.self, from: data)
                print("Found \(decoded.results.count) places")
                for (index, place) in decoded.results.enumerated() {
                    print("Place \(index + 1): \(place.name), place_id: \(place.placeId)")
                }
                DispatchQueue.main.async {
                    self?.places = decoded.results.map {
                        Place(
                            id: UUID(),
                            name: $0.name,
                            distance: $0.geometry.location.distance(from: self?.defaultLocation ?? (0,0)),
                            rating: $0.rating ?? 0,
                            lat: $0.geometry.location.lat,
                            lng: $0.geometry.location.lng,
                            placeId: $0.placeId
                        )
                    }
                }
            } catch {
                print("Decoding error: \(error)")
                DispatchQueue.main.async { self?.places = [] }
            }
        }.resume()
    }
    
    var filtered: [Place] {
        places.filter { $0.rating >= minRating && $0.distance <= maxDistance }
    }
    
    func decide() {
        selectedPlace = filtered.randomElement()
    }
    
    func feedback(liked: Bool) {
        // Placeholder for future user history logic
    }
    
    func removePlace(_ place: Place) {
        places.removeAll { $0.id == place.id }
    }
    
    func fetchPlaceDetails(placeId: String, completion: @escaping (PlaceDetail?) -> Void) {
        let urlString = "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(placeId)&key=\(apiKey)"
        print("Place Details API URL: \(urlString)")
        print("Place Details API Key: \(apiKey)")
        guard let url = URL(string: urlString) else { 
            print("Invalid URL for Place Details API")
            completion(nil); 
            return 
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            print("Place Details Error: \(error?.localizedDescription ?? "none")")
            guard let data = data, error == nil else { 
                print("No data received from Place Details API")
                completion(nil); 
                return 
            }
            print("Place Details Raw response: \(String(data: data, encoding: .utf8)?.prefix(500) ?? "")")
            do {
                let decoded = try JSONDecoder().decode(PlaceDetailResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decoded.result)
                }
            } catch {
                print("Place Details Decoding error: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
}

// MARK: - Google Places API Response Models

struct GPlacesResponse: Codable {
    let results: [GPlace]
}

struct GPlace: Codable {
    let name: String
    let geometry: GGeometry
    let rating: Double?
    let placeId: String
    
    enum CodingKeys: String, CodingKey {
        case name, geometry, rating
        case placeId = "place_id"
    }
}

struct GGeometry: Codable {
    let location: GLocation
}

struct GLocation: Codable {
    let lat: Double
    let lng: Double
    func distance(from: (lat: Double, lng: Double)) -> Double {
        let dLat = (lat - from.lat) * 111_000
        let dLng = (lng - from.lng) * 111_000
        return sqrt(dLat * dLat + dLng * dLng)
    }
} 

// MARK: - Place Details API Response Models

struct PlaceDetailResponse: Codable {
    let result: PlaceDetail
}

struct PlaceDetail: Codable {
    let name: String
    let formattedAddress: String?
    let formattedPhoneNumber: String?
    let website: String?
    let openingHours: OpeningHours?
    let priceLevel: Int?
    let rating: Double?
    let userRatingsTotal: Int?
    let types: [String]?
    let photos: [Photo]?
    let reviews: [Review]?
    
    enum CodingKeys: String, CodingKey {
        case name, website, priceLevel, rating, types, photos, reviews
        case formattedAddress = "formatted_address"
        case formattedPhoneNumber = "formatted_phone_number"
        case openingHours = "opening_hours"
        case userRatingsTotal = "user_ratings_total"
    }
}

struct OpeningHours: Codable {
    let openNow: Bool?
    let weekdayText: [String]?
    
    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
        case weekdayText = "weekday_text"
    }
}

struct Photo: Codable {
    let photoReference: String
    let height: Int
    let width: Int
    
    enum CodingKeys: String, CodingKey {
        case photoReference = "photo_reference"
        case height, width
    }
}

struct Review: Codable {
    let authorName: String
    let rating: Int
    let text: String
    let time: Int
    
    enum CodingKeys: String, CodingKey {
        case authorName = "author_name"
        case rating, text, time
    }
} 
