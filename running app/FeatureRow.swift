import SwiftUI

struct FeatureRow: View {
    var icon: String
    var title: LocalizedStringKey
    var description: LocalizedStringKey
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 40, height: 40)
                .padding(.trailing)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
