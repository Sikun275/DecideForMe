import Foundation
import SwiftUI

class ImageMarkViewModel: ObservableObject {
    @Published var marks: [ImageMark] = []
    @Published var selectedMark: ImageMark?
    @Published var selectedImage: UIImage?
    
    private var nextNumericId: Int {
        marks.isEmpty ? 1 : (marks.map { $0.numericId }.max() ?? 0) + 1
    }
    
    func addMark(at position: CGPoint) {
        let mark = ImageMark(numericId: nextNumericId, position: position)
        marks.append(mark)
    }
    
    func removeMark(_ mark: ImageMark) {
        marks.removeAll { $0.id == mark.id }
    }
    
    func renameMark(_ mark: ImageMark, newName: String) {
        if let index = marks.firstIndex(where: { $0.id == mark.id }) {
            marks[index].displayName = newName
        }
    }
    
    func selectRandomMark() {
        selectedMark = marks.randomElement()
    }
    
    func clearSelection() {
        selectedMark = nil
    }
    
    func clearAllMarks() {
        marks.removeAll()
        selectedMark = nil
    }
} 