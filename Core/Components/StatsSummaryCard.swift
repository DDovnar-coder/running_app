import SwiftUI
import Foundation

struct StatsSummaryCard: View {
    let count: Int
    let totalDuration: TimeInterval


    var body: some View {
        HStack(spacing: 16) {
            StatItem(
                title: "core.statsSummaryCard.runsLabel",
                value: "\(count)",
                systemImage: "figure.run"
            )

            StatItem(
                title: "core.statsSummaryCard.durationLabel",
                value: Duration.seconds(totalDuration).formatted(),
                systemImage: "clock"
            )
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}
