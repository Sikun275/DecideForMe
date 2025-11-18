import SwiftUI

struct AddOptionView: View {
    @ObservedObject var vm: OptionViewModel
    @Binding var newName: String
    @Binding var newTags: String
    let onAdd: () -> Void
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            HStack(spacing: AppTheme.Spacing.md) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("Option Name")
                        .font(AppTheme.Fonts.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                    TextField("e.g., Pizza, Sushi", text: $newName)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(AppTheme.Spacing.md)
                        .background(AppTheme.Colors.backgroundSecondary)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                .stroke(AppTheme.Colors.primary.opacity(0.3), lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("Tags")
                        .font(AppTheme.Fonts.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                    TextField("cheap, fast, healthy", text: $newTags)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(AppTheme.Spacing.md)
                        .background(AppTheme.Colors.backgroundSecondary)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                .stroke(AppTheme.Colors.primary.opacity(0.3), lineWidth: 1)
                        )
                }
                
                Button(action: onAdd) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(AppTheme.Colors.primary)
                }
                .disabled(newName.isEmpty)
                .scaleEffect(newName.isEmpty ? 0.8 : 1.0)
                .animation(AppTheme.Animations.easeInOut, value: newName.isEmpty)
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
