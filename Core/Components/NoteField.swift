import SwiftUI

struct Note: View {
    @Binding var ownThought: String
    @FocusState.Binding var isNoteFocused: Bool 
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("workoutSummaryView.note.title")
                .font(.subheadline)
            
            TextField("workoutSummaryView.note.placeholder", text: $ownThought,prompt: Text("workoutSummaryView.note.placeholder").foregroundStyle(Color(hex: "89938D")), axis: .vertical)
                .lineLimit(1...4)
                .fixedSize(horizontal: false, vertical: true)
                .font(.subheadline)
                .focused($isNoteFocused)
                .overlay(
                    Rectangle()
                        .frame(height: 1.5)
                        .foregroundStyle(isNoteFocused ? .blue : .clear),
                    alignment: .bottom
                )
        }
        .padding()
        .background(.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "89938D"), lineWidth: 1)
        )
    }
}
