import SwiftUI

struct MapSearchView: View {
    @ObservedObject var viewModel: MapDecisionViewModel
    @Binding var isSearching: Bool
    let onSearch: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search for a place", text: $viewModel.keyword)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
                
                Button(action: onSearch) {
                    HStack(spacing: 6) {
                        if isSearching {
                            ProgressView()
                                .scaleEffect(0.8)
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.title2)
                        }
                        Text("Search")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        viewModel.keyword.isEmpty ? 
                        AnyShapeStyle(Color.orange.opacity(0.4)) : 
                        AnyShapeStyle(LinearGradient(colors: [Color.orange, Color.orange.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                    )
                    .cornerRadius(12)
                }
                .disabled(viewModel.keyword.isEmpty || isSearching)
                .scaleEffect(viewModel.keyword.isEmpty ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: viewModel.keyword.isEmpty)
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
