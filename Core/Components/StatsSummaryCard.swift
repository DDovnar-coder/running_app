import SwiftUI
import Foundation

struct StatsSummaryCard: View {
    var count: Int
    var totalDuration: TimeInterval
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            Text("core.statsSummaryCard.title")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: "figure.run")
                        .foregroundStyle(.orange)
                    Text("core.statsSummaryCard.runsLabel")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text("\(count)")
                    .font(.title2)
                    .bold()
            }
            
            Divider()
                .frame(height: 15)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .foregroundStyle(.blue)
                    Text("core.statsSummaryCard.durationLabel")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text(Duration.seconds(totalDuration).formatted())
                    .font(.title2)
                    .bold()
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

