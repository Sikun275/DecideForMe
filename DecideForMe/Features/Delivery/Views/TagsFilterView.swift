import SwiftUI

struct TagsFilterView: View {
    @ObservedObject var vm: OptionViewModel
    
    var body: some View {
        if !vm.allTags().isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Filter by tags:")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(vm.allTags(), id: \.self) { tag in
                            let selected = vm.selectedTags.contains(tag)
                            TagView(tag: tag, isSelected: selected) {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    if selected {
                                        vm.selectedTags.remove(tag)
                                    } else {
                                        vm.selectedTags.insert(tag)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    TagsFilterView(vm: OptionViewModel())
}
