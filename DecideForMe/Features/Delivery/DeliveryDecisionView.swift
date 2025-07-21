import SwiftUI

struct DeliveryDecisionView: View {
    @StateObject var vm = OptionViewModel()
    @State private var newName = ""
    @State private var newTags = ""
    @State private var showFeedback = false
    @State private var lastDecision: Option?
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                TextField("Add option", text: $newName)
                    .textFieldStyle(.plain)
                    .padding(8)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange, lineWidth: 1))
                TextField("Tags (comma)", text: $newTags)
                    .textFieldStyle(.plain)
                    .padding(8)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange, lineWidth: 1))
                Button("+") {
                    guard !newName.isEmpty else { return }
                    let tags = newTags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                    vm.addOption(name: newName, tags: tags)
                    newName = ""; newTags = ""
                }
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.orange)
                .cornerRadius(8)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(vm.allTags(), id: \.self) { tag in
                        let selected = vm.selectedTags.contains(tag)
                        Text(tag)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(selected ? Color.orange : Color.white)
                            .foregroundColor(selected ? .white : .black)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 1))
                            .onTapGesture {
                                if selected { vm.selectedTags.remove(tag) } else { vm.selectedTags.insert(tag) }
                            }
                    }
                }
                .padding(.vertical, 4)
            }
            
            List {
                ForEach(vm.filteredOptions) { option in
                    HStack {
                        Text(option.name)
                            .fontWeight(.medium)
                        Spacer()
                        Text(option.tags.joined(separator: ", "))
                            .font(.caption)
                            .foregroundColor(.orange)
                        Button("✕") { vm.removeOption(option) }
                            .buttonStyle(BorderlessButtonStyle())
                            .foregroundColor(.orange)
                    }
                }
            }
            .frame(maxHeight: 200)
            .listStyle(.plain)
            
            Button("Decide") {
                vm.decide()
                lastDecision = vm.selectedOption
                showFeedback = vm.selectedOption != nil
            }
            .font(.title3.bold())
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(vm.filteredOptions.isEmpty ? Color.orange.opacity(0.4) : Color.orange)
            .cornerRadius(12)
            .disabled(vm.filteredOptions.isEmpty)
            
            if let option = vm.selectedOption {
                VStack {
                    Text(option.name)
                        .font(.title2.bold())
                        .foregroundColor(.orange)
                    Text(option.tags.joined(separator: ", ")).font(.caption)
                    if showFeedback {
                        HStack(spacing: 24) {
                            Button("👍") { vm.feedback(liked: true); showFeedback = false }
                                .font(.title2)
                                .foregroundColor(.orange)
                            Button("👎") { vm.feedback(liked: false); showFeedback = false }
                                .font(.title2)
                                .foregroundColor(.orange)
                        }
                    }
                }
                .padding(.top, 8)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .navigationTitle("")
    }
}

#Preview {
    DeliveryDecisionView()
} 