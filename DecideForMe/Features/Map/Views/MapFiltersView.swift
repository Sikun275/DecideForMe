import SwiftUI

struct MapFiltersView: View {
    @ObservedObject var viewModel: MapDecisionViewModel
    @Binding var showFilters: Bool
    @State private var minRatingInput = ""
    @State private var maxDistanceInput = ""
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Button(action: { withAnimation(AppTheme.Animations.spring) { showFilters.toggle() } }) {
                HStack {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 14, weight: .medium))
                    Text("Filters")
                        .font(AppTheme.Fonts.body)
                    Spacer()
                    Image(systemName: showFilters ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(AppTheme.Colors.primary)
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.vertical, AppTheme.Spacing.md)
                .background(AppTheme.Colors.primaryLight)
                .cornerRadius(AppTheme.CornerRadius.medium)
            }
            .buttonStyle(PlainButtonStyle())
            
            if showFilters {
                VStack(spacing: AppTheme.Spacing.lg) {
                    HStack(spacing: AppTheme.Spacing.lg) {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                            Text("Min Rating")
                                .font(AppTheme.Fonts.caption)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                                .fixedSize(horizontal: true, vertical: false)
                            TextField("0-5", text: $minRatingInput)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(AppTheme.Spacing.sm)
                                .background(AppTheme.Colors.backgroundSecondary)
                                .cornerRadius(AppTheme.CornerRadius.small)
                                .frame(width: 80)
                        }
                        .frame(minWidth: 100)
                        
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                            Text("Max Distance (km)")
                                .font(AppTheme.Fonts.caption)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                                .fixedSize(horizontal: true, vertical: false)
                            TextField("0.1-50", text: $maxDistanceInput)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(AppTheme.Spacing.sm)
                                .background(AppTheme.Colors.backgroundSecondary)
                                .cornerRadius(AppTheme.CornerRadius.small)
                                .frame(width: 100)
                        }
                        .frame(minWidth: 130)
                        
                        Button("Set") {
                            // Set min rating if valid
                            if let ratingVal = Double(minRatingInput), ratingVal >= 0, ratingVal <= 5 {
                                viewModel.minRating = ratingVal
                                minRatingInput = ""
                            }
                            
                            // Set max distance if valid
                            if let distanceVal = Double(maxDistanceInput), distanceVal >= 0.1, distanceVal <= 50 {
                                viewModel.maxDistance = distanceVal * 1000
                                maxDistanceInput = ""
                            }
                        }
                        .font(AppTheme.Fonts.caption)
                        .foregroundColor(AppTheme.Colors.textOnPrimary)
                        .padding(.horizontal, AppTheme.Spacing.sm)
                        .padding(.vertical, AppTheme.Spacing.xs)
                        .background(AppTheme.Colors.primary)
                        .cornerRadius(AppTheme.CornerRadius.small)
                    }
                    
                    HStack {
                        Text("Current: ⭐️ \(String(format: "%.1f", viewModel.minRating)) | 📍 \(String(format: "%.1f", viewModel.maxDistance / 1000)) km")
                            .font(AppTheme.Fonts.caption)
                            .foregroundColor(AppTheme.Colors.textSecondary)

                        Spacer()
                        
                        Button("Reset") {
                            viewModel.minRating = 0
                            viewModel.maxDistance = 5000
                        }
                        .font(AppTheme.Fonts.caption)
                        .foregroundColor(AppTheme.Colors.primary)
                    }
                }
                .padding(AppTheme.Spacing.lg)
                .background(AppTheme.Colors.backgroundSecondary)
                .cornerRadius(AppTheme.CornerRadius.medium)
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
