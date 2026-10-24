import SwiftUI


struct NoteCard<Content: View>: View {
    let content: Content
    let isHighlighted: Bool
    
    init(isHighlighted: Bool = false, @ViewBuilder content: () -> Content) {
        self.isHighlighted = isHighlighted
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("workoutSummaryView.note.title")
                .font(.subheadline)
            
            content
        }
        .padding()
        .background(.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(
                    isHighlighted ? Color.blue : Color(hex: "89938D").opacity(0.4),
                    lineWidth: 1.0
                )
        )
        
        .animation(.default, value: isHighlighted)
    }
}
