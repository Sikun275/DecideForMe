import SwiftUI

struct MapSearchView: View {
    @ObservedObject var viewModel: MapDecisionViewModel
    @Binding var isSearching: Bool
    let onSearch: () -> Void
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            HStack(spacing: AppTheme.Spacing.md) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppTheme.Colors.textSecondary)
                    TextField("Search for a place", text: $viewModel.keyword)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(AppTheme.Spacing.md)
                .background(AppTheme.Colors.backgroundSecondary)
                .cornerRadius(AppTheme.CornerRadius.medium)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(AppTheme.Colors.primary.opacity(0.3), lineWidth: 1)
                )
                
                Button(action: onSearch) {
                    HStack(spacing: 6) {
                        if isSearching {
                            ProgressView()
                                .scaleEffect(0.8)
                                .foregroundColor(AppTheme.Colors.textOnPrimary)
                        } else {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.title2)
                        }
                        Text("Search")
                            .font(AppTheme.Fonts.body)
                    }
                }
                .primaryButton(isEnabled: !viewModel.keyword.isEmpty && !isSearching, size: .medium)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    MapSearchView(
        viewModel: MapDecisionViewModel(),
        isSearching: .constant(false),
        onSearch: {}
    )
}
