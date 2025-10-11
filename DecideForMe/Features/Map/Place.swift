import Foundation

struct Place: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let distance: Double // in meters
    let rating: Double // 0-5
    let lat: Double
    let lng: Double
    let placeId: String
    var weight: Int
    
    init(name: String, distance: Double, rating: Double, lat: Double, lng: Double, placeId: String, weight: Int = 1) {
        self.id = UUID()
        self.name = name
        self.distance = distance
        self.rating = rating
        self.lat = lat
        self.lng = lng
        self.placeId = placeId
        self.weight = weight
    }
    
    static let storageKey = "places"
    
    static func load() -> [Place] {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let places = try? JSONDecoder().decode([Place].self, from: data) else { return [] }
        return places
    }
    
    static func save(_ places: [Place]) {
        if let data = try? JSONEncoder().encode(places) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    // Combined score that considers both distance and weight
    func combinedScore() -> Double {
        // Normalize distance (closer is better, so we invert it)
        let maxDistance = 50000.0 // 50km as max reasonable distance
        let normalizedDistance = 1.0 - (distance / maxDistance)
        
        // Normalize weight (higher weight is better)
        let maxWeight = 10.0 // Assume max weight of 10
        let normalizedWeight = Double(weight) / maxWeight
        
        // Combine with 70% weight on distance, 30% on user preference
        return (normalizedDistance * 0.7) + (normalizedWeight * 0.3)
    }
} 