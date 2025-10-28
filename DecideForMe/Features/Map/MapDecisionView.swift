import SwiftUI

struct MapDecisionView: View {
    @StateObject var vm = MapDecisionViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showMap = false
    @State private var isSearching = false
    @State private var showFilters = false
    
    var body: some View {
        ZStack {
            // Background
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                MapHeaderView()
                
                // Search Section
                MapSearchView(
                    viewModel: vm,
                    isSearching: $isSearching,
                    onSearch: performSearch
                )
                
                // Filters Section
                MapFiltersView(
                    viewModel: vm,
                    showFilters: $showFilters
                )
                
                // Results Section
                MapResultsView(viewModel: vm)
                
                Spacer()
                
                // Decision Section
                VStack(spacing: 16) {
                    if let place = vm.selectedPlace {
                        PlaceDecisionView(place: place, showMap: $showMap) { liked in
                            vm.feedback(liked: liked)
                            withAnimation(.easeInOut(duration: 0.5)) {
                                vm.selectedPlace = nil
                            }
                        }
                    } else {
                        MapDecisionButtonView(viewModel: vm, onDecision: makeDecision)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.orange)
                }
            }
        }
        .onAppear {
            vm.requestLocationPermission()
        }
        .sheet(isPresented: $showMap) {
            NearbyMapViewContainer(lat: vm.selectedPlace?.lat ?? 0, lng: vm.selectedPlace?.lng ?? 0, apiKey: Bundle.main.infoDictionary?["GOOGLE_PLACES_API_KEY"] as? String ?? "")
        }
    }
    
    private func performSearch() {
        guard !vm.keyword.isEmpty else { return }
        
        isSearching = true
        
        vm.search()
        
        // Simulate search delay for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isSearching = false
        }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func makeDecision() {
        vm.decide()
        
        if vm.selectedPlace != nil {
            // Haptic feedback
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.success)
        }
    }
}

#Preview {
    NavigationView {
        MapDecisionView()
    }
} 
