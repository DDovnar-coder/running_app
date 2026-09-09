import SwiftUI

struct MetricStat: View {
    var value: String
    var unit: String
    let label: LocalizedStringKey
    
    var body: some View {
        VStack(spacing: 2) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 22, weight: .medium))
                    .monospacedDigit()
                Text(unit)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
