import Foundation

struct Place: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let distance: Double // in meters
    let rating: Double // 0-5
    let lat: Double
    let lng: Double
    let placeId: String
} 