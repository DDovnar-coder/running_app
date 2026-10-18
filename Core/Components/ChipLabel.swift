import SwiftUI

enum ChipStyle {
    case selected    // Зеленый (для экрана выбора)
    case unselected  // Белый с серой рамкой (для экрана выбора)
    case archival    // Нейтральный серый (для экрана деталей/архива)
}

struct ChipLabel: View {
    let title: LocalizedStringKey
    let style: ChipStyle
    
    var body: some View {
        Text(title)
            .font(.system(.body, design: .rounded))
            .fontWeight(.medium)
            .foregroundStyle(textColor)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Capsule().fill(backgroundColor))
            .overlay{
                if let strokeColor = borderColor {
                    Capsule().stroke(strokeColor, lineWidth: 1)
                }
            }
    }
    
    private var textColor: Color {
        switch style {
        case .selected:   return Color(hex: "1A5333")
        case .unselected: return Color(hex: "4A4A4A")
        case .archival:   return Color(hex: "333333")
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .selected:   return Color(hex: "E2F5E9")
        case .unselected: return .white
        case .archival:   return Color(hex: "F2F2F7")
        }
    }
    
    private var borderColor: Color? {
        switch style {
        case .selected:   return Color(hex: "A3E2BD")
        case .unselected: return Color(hex: "E6E6E6")
        case .archival:   return nil
        }
    }
}
