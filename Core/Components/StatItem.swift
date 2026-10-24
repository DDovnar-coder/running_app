import SwiftUI

struct StatItem: View {
    let title: LocalizedStringKey
    let value: String
    let systemImage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(Color(hex: "1683FF"))
                .frame(width: 56, height: 56)
                .background(Color(hex: "E5F0FF"))
                .clipShape(Circle())
            
            Text(title)
                .font(.subheadline)
                .foregroundStyle(Color(hex: "8491A7"))
            
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(Color(hex: "101828"))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}
