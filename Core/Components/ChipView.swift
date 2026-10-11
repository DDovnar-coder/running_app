import SwiftUI

struct ChipView: View {
    let title: LocalizedStringKey
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(.body, design: .rounded))
                .fontWeight(.medium)
                .foregroundStyle(isSelected ? Color(hex: "1A5333") : Color(hex: "4A4A4A"))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color(hex: "E2F5E9") : .white)
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color(hex: "A3E2BD") : Color(hex: "E6E6E6"), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}


