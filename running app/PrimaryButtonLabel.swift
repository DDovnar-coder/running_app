import SwiftUI

struct PrimaryButtonLabel: View {
    var title: LocalizedStringKey
    
    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity)
    }
}
