import SwiftUI
import PhotosUI

struct ImageMarkView: View {
    @StateObject private var vm = ImageMarkViewModel()
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var showingSourceActionSheet = false
    @State private var showingRenameAlert = false
    @State private var markToRename: ImageMark?
    @State private var newMarkName = ""
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button("Select Image") {
                    showingSourceActionSheet = true
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
                
                if !vm.marks.isEmpty {
                    Button("Clear All") {
                        vm.clearAllMarks()
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                }
            }
            .padding(.horizontal)
            
            if let image = vm.selectedImage {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 400)
                        .onTapGesture { location in
                            vm.addMark(at: location)
                        }
                    
                    // Display existing marks
                    ForEach(vm.marks) { mark in
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(vm.selectedMark?.id == mark.id ? .red : .blue)
                                .font(.title)
                            Text(mark.displayName)
                                .font(.caption)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(4)
                        }
                        .position(mark.position)
                        .onTapGesture {
                            vm.removeMark(mark)
                        }
                        .onLongPressGesture {
                            markToRename = mark
                            newMarkName = mark.displayName
                            showingRenameAlert = true
                        }
                    }
                }
                .frame(maxHeight: 400)
                .clipped()
            } else {
                VStack {
                    Image(systemName: "photo")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("Select an image to start marking")
                        .foregroundColor(.gray)
                }
                .frame(maxHeight: 400)
            }
            
            if !vm.marks.isEmpty {
                VStack(spacing: 12) {
                    Text("Marks (\(vm.marks.count)):")
                        .font(.headline)
                        .padding(.top, 4)
                    
                    // Wrapping grid for marks
                    let columns = [GridItem(.adaptive(minimum: 90, maximum: 160), spacing: 10)]
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                        ForEach(vm.marks) { mark in
                            Text(mark.displayName)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(vm.selectedMark?.id == mark.id ? Color.red.opacity(0.25) : Color.blue.opacity(0.18))
                                .foregroundColor(.primary)
                                .cornerRadius(12)
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(vm.selectedMark?.id == mark.id ? Color.red : Color.blue, lineWidth: vm.selectedMark?.id == mark.id ? 2 : 1)
                                )
                                .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
                                .animation(.easeInOut(duration: 0.2), value: vm.selectedMark?.id == mark.id)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            Spacer()
            if !vm.marks.isEmpty {
                Button("Select Random Mark") {
                    withAnimation(.spring()) {
                        vm.selectRandomMark()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(vm.marks.isEmpty)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Image Marking")
        .actionSheet(isPresented: $showingSourceActionSheet) {
            ActionSheet(title: Text("Select Image Source"), buttons: [
                .default(Text("Photo Library")) { showingImagePicker = true },
                .default(Text("Camera")) { showingCamera = true },
                .cancel()
            ])
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $vm.selectedImage)
        }
        .sheet(isPresented: $showingCamera) {
            CameraPicker(image: $vm.selectedImage)
        }
        .alert("Rename Mark", isPresented: $showingRenameAlert) {
            TextField("Mark name", text: $newMarkName)
            Button("Rename") {
                if let mark = markToRename, !newMarkName.isEmpty {
                    vm.renameMark(mark, newName: newMarkName)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.image = image as? UIImage
                    }
                }
            }
        }
    }
}

struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker
        
        init(_ parent: CameraPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    ImageMarkView()
} 