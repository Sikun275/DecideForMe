import SwiftUI

struct DecisionResultView: View {
    let option: Option
    @Binding var showFeedback: Bool
    let onFeedback: (Bool) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.orange)
                
                Text("We chose for you!")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(option.name)
                    .font(.title2.bold())
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.center)
                
                if !option.tags.isEmpty {
                    Text(option.tags.joined(separator: " • "))
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(20)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(16)
            
            if showFeedback {
                HStack(spacing: 24) {
                    Button(action: { onFeedback(true) }) {
                        VStack(spacing: 4) {
                            Image(systemName: "hand.thumbsup.fill")
                                .font(.title2)
                            Text("Good Choice")
                                .font(.caption)
                        }
                        .foregroundColor(.green)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    Button(action: { onFeedback(false) }) {
                        VStack(spacing: 4) {
                            Image(systemName: "hand.thumbsdown.fill")
                                .font(.title2)
                            Text("Not Great")
                                .font(.caption)
                        }
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview {
    DecisionResultView(
        option: Option(id: UUID(), name: "Pizza", tags: ["fast", "delicious"], weight: 3),
        showFeedback: .constant(true),
        onFeedback: { _ in }
    )
}
