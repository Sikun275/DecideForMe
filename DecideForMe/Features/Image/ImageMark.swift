import Foundation
import SwiftUI

struct ImageMark: Identifiable, Codable, Equatable {
    let id: UUID
    let numericId: Int
    var displayName: String
    var position: CGPoint
    
    init(numericId: Int, position: CGPoint) {
        self.id = UUID()
        self.numericId = numericId
        self.displayName = "Mark \(numericId)"
        self.position = position
    }
    
    enum CodingKeys: String, CodingKey {
        case id, numericId, displayName, positionX, positionY
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        numericId = try container.decode(Int.self, forKey: .numericId)
        displayName = try container.decode(String.self, forKey: .displayName)
        let x = try container.decode(Double.self, forKey: .positionX)
        let y = try container.decode(Double.self, forKey: .positionY)
        position = CGPoint(x: x, y: y)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(numericId, forKey: .numericId)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(position.x, forKey: .positionX)
        try container.encode(position.y, forKey: .positionY)
    }
} 