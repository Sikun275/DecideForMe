import SwiftUI

struct MapFiltersView: View {
    @ObservedObject var viewModel: MapDecisionViewModel
    @Binding var showFilters: Bool
    @State private var minRatingInput = ""
    @State private var maxDistanceInput = ""
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: { withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) { showFilters.toggle() } }) {
                HStack {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 14, weight: .medium))
                    Text("Filters")
                        .font(.system(size: 14, weight: .medium))
                    Spacer()
                    Image(systemName: showFilters ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(.orange)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
            
            if showFilters {
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Min Rating")
                                .font(.caption)
                                .foregroundColor(.gray)
                            HStack {
                                TextField("0-5", text: $minRatingInput)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(8)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                    .frame(width: 60)
                                
                                Button("Set") {
                                    if let val = Double(minRatingInput), val >= 0, val <= 5 {
                                        viewModel.minRating = val
                                        minRatingInput = ""
                                    }
                                }
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.orange)
                                .cornerRadius(6)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Max Distance (km)")
                                .font(.caption)
                                .foregroundColor(.gray)
                            HStack {
                                TextField("0.1-50", text: $maxDistanceInput)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(8)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                    .frame(width: 80)
                                
                                Button("Set") {
                                    if let val = Double(maxDistanceInput), val >= 0.1, val <= 50 {
                                        viewModel.maxDistance = val * 1000
                                        maxDistanceInput = ""
                                    }
                                }
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.orange)
                                .cornerRadius(6)
                            }
                        }
                    }
                    
                    HStack {
                        Text("Current: ⭐️ \(String(format: "%.1f", viewModel.minRating)) | 📍 \(String(format: "%.1f", viewModel.maxDistance / 1000)) km")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                        Button("Reset") {
                            viewModel.minRating = 0
                            viewModel.maxDistance = 5000
                        }
                        .font(.caption)
                        .foregroundColor(.orange)
                    }
                }
                .padding(16)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.9).combined(with: .opacity),
                    removal: .scale(scale: 0.9).combined(with: .opacity)
                ))
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    MapFiltersView(
        viewModel: MapDecisionViewModel(),
        showFilters: .constant(true)
    )
}
