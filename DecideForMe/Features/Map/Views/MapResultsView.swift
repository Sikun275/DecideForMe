import SwiftUI

struct MapResultsView: View {
    @ObservedObject var viewModel: MapDecisionViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Results (\(viewModel.filtered.count))")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                if !viewModel.filtered.isEmpty {
                    Button("Clear All") {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            viewModel.clearAllPlaces()
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.orange)
                }
            }
            .padding(.horizontal)
            
            // Preview Mode Hint
            if !viewModel.filtered.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "eye.fill")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Text("Tap the info button to preview details before deciding!")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
            }
            
            if viewModel.filtered.isEmpty {
                // Show appropriate warning message based on error state
                if viewModel.searchErrorState != .none {
                    ErrorWarningView(errorState: viewModel.searchErrorState)
                } else {
                    EmptyResultsView()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.filtered) { place in
                            PlaceRowView(place: place, viewModel: viewModel) {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    viewModel.removePlace(place)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: 300)
            }
        }
    }
}

struct EmptyResultsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "map")
                .font(.system(size: 40))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No places found")
                .font(.headline)
                .foregroundColor(.gray)
            
            Text("Try searching for a different keyword or adjusting your filters")
                .font(.caption)
                .foregroundColor(.gray.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
    }
}

struct ErrorWarningView: View {
    let errorState: SearchErrorState
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: errorState.icon)
                .font(.system(size: 40))
                .foregroundColor(errorState.color)
            
            Text(errorState.message)
                .font(.headline)
                .foregroundColor(errorState.color)
                .multilineTextAlignment(.center)
            
            // Additional helpful hints based on error type
            if case .apiKeyInvalid = errorState {
                Text("Check your Secrets.xcconfig file and ensure the API key is valid")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.7))
                    .multilineTextAlignment(.center)
            } else if case .networkError = errorState {
                Text("Make sure you're connected to the internet")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.7))
                    .multilineTextAlignment(.center)
            } else if case .filtersTooRestrictive = errorState {
                Text("Lower the minimum rating or increase the maximum distance")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.7))
                    .multilineTextAlignment(.center)
            } else if case .locationDenied = errorState {
                Text("You can still search, but results will be based on Toronto location")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(errorState.color.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    MapResultsView(viewModel: MapDecisionViewModel())
}
