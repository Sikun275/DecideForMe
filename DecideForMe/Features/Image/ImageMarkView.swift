import SwiftUI
import PhotosUI

struct ImageMarkView: View {
    @StateObject private var vm = ImageMarkViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var showingSourceActionSheet = false
    @State private var showingRenameAlert = false
    @State private var markToRename: ImageMark?
    @State private var newMarkName = ""
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 16) {
                ImageHeaderView()
                ImageSelectionView(vm: vm, showingSourceActionSheet: $showingSourceActionSheet)
                ImageDisplayView(vm: vm)
                MarksListView(vm: vm)
                ImageDecisionButtonView(vm: vm)
            }
            .padding(.horizontal)
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
        .confirmationDialog("Select Image Source", isPresented: $showingSourceActionSheet) {
            Button("Photo Library") {
                showingImagePicker = true
            }
            Button("Camera") {
                showingCamera = true
            }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $vm.selectedImage)
        }
        .sheet(isPresented: $showingCamera) {
            CameraPicker(image: $vm.selectedImage)
        }
        .alert("Rename Mark", isPresented: $showingRenameAlert) {
            TextField("Mark name", text: $newMarkName)
            Button("Cancel", role: .cancel) { }
            Button("Rename") {
                if let mark = markToRename, !newMarkName.isEmpty {
                    vm.renameMark(mark, newName: newMarkName)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ImageMarkView()
    }
} 