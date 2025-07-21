import Foundation

struct Option: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var tags: [String]
    var weight: Int
    
    static let storageKey = "options"
    
    static func load() -> [Option] {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let options = try? JSONDecoder().decode([Option].self, from: data) else { return [] }
        return options
    }
    
    static func save(_ options: [Option]) {
        if let data = try? JSONEncoder().encode(options) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
} 