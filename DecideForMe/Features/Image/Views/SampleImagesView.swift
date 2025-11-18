import SwiftUI

struct SampleImagesView: View {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    @State private var sampleImages: [(name: String, image: UIImage)] = []
    
    var body: some View {
        NavigationView {
            Group {
                if sampleImages.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 60))
                            .foregroundColor(AppTheme.Colors.textTertiary)
                        Text("No Sample Images")
                            .font(AppTheme.Fonts.headline)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                        Text("Add images to the SampleImages folder")
                            .font(AppTheme.Fonts.caption)
                            .foregroundColor(AppTheme.Colors.textTertiary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: AppTheme.Spacing.md),
                            GridItem(.flexible(), spacing: AppTheme.Spacing.md)
                        ], spacing: AppTheme.Spacing.lg) {
                            ForEach(sampleImages.indices, id: \.self) { index in
                                Button(action: {
                                    selectedImage = sampleImages[index].image
                                    dismiss()
                                }) {
                                    ZStack(alignment: .bottomLeading) {
                                        Image(uiImage: sampleImages[index].image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 180)
                                            .clipped()
                                            .cornerRadius(AppTheme.CornerRadius.medium)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                                    .stroke(AppTheme.Colors.primary.opacity(0.3), lineWidth: 2)
                                            )
                                        
                                        // Image name overlay
                                        Text(sampleImages[index].name)
                                            .font(AppTheme.Fonts.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(AppTheme.Colors.textOnPrimary)
                                            .padding(.horizontal, AppTheme.Spacing.sm)
                                            .padding(.vertical, AppTheme.Spacing.xs)
                                            .background(AppTheme.Colors.textPrimary.opacity(0.6))
                                            .cornerRadius(6)
                                            .padding(.leading, AppTheme.Spacing.sm)
                                            .padding(.bottom, AppTheme.Spacing.sm)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(AppTheme.Spacing.lg)
                    }
                }
            }
            .navigationTitle("Sample Images")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.Colors.primary)
                }
            }
            .onAppear {
                loadSampleImages()
            }
        }
    }
    
    private func loadSampleImages() {
        // Load images from SampleImages folder in the app bundle
        // Try multiple naming patterns since Xcode handles folder references differently
        let imageNames = [
            "drink_shelf",
            "bread_shelf"
        ]
        
        var loadedImages: [(name: String, image: UIImage)] = []
        
        for imageName in imageNames {
            // Try different path patterns
            var image: UIImage? = nil
            
            // Pattern 1: With folder path
            image = UIImage(named: "SampleImages/\(imageName)")
            
            // Pattern 2: Direct name (if images are in root of bundle)
            if image == nil {
                image = UIImage(named: imageName)
            }
            
            // Pattern 3: With different folder separator
            if image == nil {
                image = UIImage(named: "SampleImages.\(imageName)")
            }
            
            // Pattern 4: Try with file extension
            if image == nil {
                image = UIImage(named: "SampleImages/\(imageName).jpg") ?? 
                        UIImage(named: "SampleImages/\(imageName).png") ??
                        UIImage(named: "\(imageName).jpg") ??
                        UIImage(named: "\(imageName).png")
            }
            
            if let loadedImage = image {
                // Extract a readable name from the filename
                let displayName = imageName
                    .replacingOccurrences(of: "_", with: " ")
                    .replacingOccurrences(of: "-", with: " ")
                    .capitalized
                loadedImages.append((name: displayName, image: loadedImage))
            }
        }
        
        sampleImages = loadedImages
    }
}

#Preview {
    SampleImagesView(selectedImage: .constant(nil))
}

