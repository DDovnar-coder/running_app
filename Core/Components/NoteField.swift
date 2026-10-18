import SwiftUI

struct NoteField: View {
    @Binding var ownThought: String
    @FocusState.Binding var isNoteFocused: Bool 
    
    var body: some View {
        NoteCard(isHighlighted: isNoteFocused) {
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
       
    }
    
   
}
