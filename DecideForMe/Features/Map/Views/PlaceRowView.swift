import SwiftUI

struct PlaceRowView: View {
    let place: Place
    let viewModel: MapDecisionViewModel
    let onDelete: () -> Void
    @State private var showingDetailPreview = false
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(place.name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                HStack(spacing: AppTheme.Spacing.md) {
                    HStack(spacing: AppTheme.Spacing.xs) {
                        Image(systemName: "location")
                            .font(AppTheme.Fonts.caption)
                            .foregroundColor(AppTheme.Colors.primary)
                        Text(String(format: "%.2f km", place.distance / 1000))
                            .font(AppTheme.Fonts.caption)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    
                    HStack(spacing: AppTheme.Spacing.xs) {
                        Image(systemName: "star.fill")
                            .font(AppTheme.Fonts.caption)
                            .foregroundColor(AppTheme.Colors.primary)
                        Text(String(format: "%.1f", place.rating))
                            .font(AppTheme.Fonts.caption)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    
                    HStack(spacing: AppTheme.Spacing.xs) {
                        Image(systemName: "hand.thumbsup.fill")
                            .font(AppTheme.Fonts.caption)
                            .foregroundColor(AppTheme.Colors.primary)
                        Text("\(place.weight)")
                            .font(AppTheme.Fonts.caption)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                }
            }
            
            Spacer()
            
            HStack(spacing: AppTheme.Spacing.sm) {
                Button(action: { showingDetailPreview = true }) {
                    Image(systemName: "info.circle.fill")
                        .font(.title3)
                        .foregroundColor(.blue.opacity(0.7))
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: onDelete) {
                    Image(systemName: "trash.circle.fill")
                        .font(.title3)
                        .foregroundColor(AppTheme.Colors.secondary.opacity(0.7))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.backgroundSecondary)
        .cornerRadius(AppTheme.CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .stroke(AppTheme.Colors.textSecondary.opacity(0.2), lineWidth: 1)
        )
        .sheet(isPresented: $showingDetailPreview) {
            PlaceDetailPreviewView(place: place, viewModel: viewModel)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        PlaceRowView(
            place: Place(name: "Sample Rest 1", distance: 150, rating: 4.5, lat: 37.7749, lng: -122.4194, placeId: "sample_1_id"),
            viewModel: MapDecisionViewModel(),
            onDelete: {}
        )
        
        PlaceRowView(
            place: Place(name: "Bella Vista Italian", distance: 850, rating: 4.8, lat: 37.7849, lng: -122.4094, placeId: "sample_2_id"),
            viewModel: MapDecisionViewModel(),
            onDelete: {}
        )
    }
    .padding()
}
