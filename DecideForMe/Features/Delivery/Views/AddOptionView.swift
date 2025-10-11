import SwiftUI

struct AddOptionView: View {
    @ObservedObject var vm: OptionViewModel
    @Binding var newName: String
    @Binding var newTags: String
    let onAdd: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Option Name")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField("e.g., Pizza, Sushi", text: $newName)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Tags")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField("cheap, fast, healthy", text: $newTags)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
                }
                
                Button(action: onAdd) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.orange)
                }
                .disabled(newName.isEmpty)
                .scaleEffect(newName.isEmpty ? 0.8 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: newName.isEmpty)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    AddOptionView(
        vm: OptionViewModel(),
        newName: .constant(""),
        newTags: .constant(""),
        onAdd: {}
    )
}
