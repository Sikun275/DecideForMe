import SwiftUI

struct TagView: View {
    let tag: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(tag)
                .font(AppTheme.Fonts.caption)
        }
        .tagButton(isSelected: isSelected)
    }
}

#Preview {
    TagView(tag: "1", isSelected: true, action: {})
    TagView(tag: "2", isSelected: false, action: {})
}
