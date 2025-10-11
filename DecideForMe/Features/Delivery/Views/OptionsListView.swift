import SwiftUI

struct OptionsListView: View {
    @ObservedObject var vm: OptionViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Options (\(vm.filteredOptions.count))")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                if !vm.filteredOptions.isEmpty {
                    Button("Clear All") {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            vm.clearAllOptions()
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.orange)
                }
            }
            .padding(.horizontal)
            
            if vm.filteredOptions.isEmpty {
                EmptyStateView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(vm.filteredOptions) { option in
                            OptionRowView(option: option) {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    vm.removeOption(option)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: 250)
            }
        }
    }
}

#Preview {
    OptionsListView(vm: OptionViewModel())
}
