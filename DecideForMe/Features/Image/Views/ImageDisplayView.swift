import SwiftUI

struct ImageDisplayView: View {
    @ObservedObject var vm: ImageMarkViewModel
    @State private var imageSize: CGSize = .zero
    @State private var displaySize: CGSize = .zero
    
    var body: some View {
        if let image = vm.selectedImage {
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 400)
                    .cornerRadius(AppTheme.CornerRadius.large)
                    .applyShadow(AppTheme.Shadows.small)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                            .stroke(AppTheme.Colors.primary.opacity(0.3), lineWidth: 2)
                    )
                    .onTapGesture { location in
                        addMark(at: location)
                    }
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    imageSize = image.size
                                    displaySize = geometry.size
                                }
                                .onChange(of: geometry.size) { _, newSize in
                                    displaySize = newSize
                                }
                        }
                    )
                
                // Display existing marks with proper scaling
                ForEach(vm.marks) { mark in
                    MarkView(
                        mark: mark, 
                        isSelected: vm.selectedMark?.id == mark.id,
                        imageSize: imageSize,
                        displaySize: displaySize
                    ) {
                        withAnimation(AppTheme.Animations.spring) {
                            vm.removeMark(mark)
                        }
                    }
                }
            }
            .frame(maxHeight: 400)
            .clipped()
        } else {
            EmptyImageView()
        }
    }
    
    private func addMark(at location: CGPoint) {
        // Convert tap location to original image coordinates
        let scaledLocation = convertToImageCoordinates(location)
        
        withAnimation(AppTheme.Animations.spring) {
            vm.addMark(at: scaledLocation)
        }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func convertToImageCoordinates(_ displayPoint: CGPoint) -> CGPoint {
        guard imageSize.width > 0 && imageSize.height > 0,
              displaySize.width > 0 && displaySize.height > 0 else {
            return displayPoint
        }
        
        // Calculate the scale factors
        let scaleX = imageSize.width / displaySize.width
        let scaleY = imageSize.height / displaySize.height
        
        // Convert display coordinates to image coordinates
        return CGPoint(
            x: displayPoint.x * scaleX,
            y: displayPoint.y * scaleY
        )
    }
}

#Preview {
    ImageDisplayView(vm: ImageMarkViewModel())
}
