import SwiftUI

struct MarksListView: View {
    @ObservedObject var vm: ImageMarkViewModel
    
    var body: some View {
        if !vm.marks.isEmpty {
            VStack(spacing: 12) {
                HStack {
                    Text("Marks (\(vm.marks.count))")
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                    if vm.selectedMark != nil {
                        Button("Clear Selection") {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                vm.clearSelection()
                            }
                        }
                        .font(.caption)
                        .foregroundColor(.orange)
                    }
                }
                
                let columns = [GridItem(.adaptive(minimum: 90, maximum: 160), spacing: 10)]
                LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                    ForEach(vm.marks) { mark in
                        MarkCardView(mark: mark, isSelected: vm.selectedMark?.id == mark.id) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                vm.selectMark(mark)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MarksListView(vm: ImageMarkViewModel())
}
