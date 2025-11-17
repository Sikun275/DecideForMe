import SwiftUI

// MARK: - Search Error States
enum SearchErrorState: Equatable {
    case none
    case noSearchPerformed
    case emptyKeyword
    case networkError
    case apiKeyInvalid
    case apiError(String) // Contains error message from API
    case zeroResults
    case locationDenied
    case filtersTooRestrictive
    case unknownError
    
    var message: String {
        switch self {
        case .none:
            return ""
        case .noSearchPerformed:
            return "Enter a keyword and search for places"
        case .emptyKeyword:
            return "Please enter a search keyword"
        case .networkError:
            return "Network connection error. Please check your internet connection."
        case .apiKeyInvalid:
            return "API configuration error. Please check your Google Places API key."
        case .apiError(let message):
            return "API Error: \(message)"
        case .zeroResults:
            return "No places found. Try a different keyword or adjust your filters."
        case .locationDenied:
            return "Location permission denied. Using default location (Toronto)."
        case .filtersTooRestrictive:
            return "No results match your filters. Try adjusting rating or distance filters."
        case .unknownError:
            return "An unexpected error occurred. Please try again."
        }
    }
    
    var icon: String {
        switch self {
        case .none:
            return ""
        case .noSearchPerformed:
            return "magnifyingglass"
        case .emptyKeyword:
            return "text.cursor"
        case .networkError:
            return "wifi.slash"
        case .apiKeyInvalid:
            return "key.fill"
        case .apiError:
            return "exclamationmark.triangle.fill"
        case .zeroResults:
            return "map"
        case .locationDenied:
            return "location.slash"
        case .filtersTooRestrictive:
            return "line.3.horizontal.decrease.circle"
        case .unknownError:
            return "questionmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .none:
            return .clear
        case .noSearchPerformed, .emptyKeyword:
            return .blue
        case .networkError, .apiKeyInvalid, .apiError, .unknownError:
            return .red
        case .zeroResults, .locationDenied:
            return .orange
        case .filtersTooRestrictive:
            return .yellow
        }
    }
}

