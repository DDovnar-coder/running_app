
import SwiftUI
import Charts

struct WeeklyStatsCardView: View {

    // Входные параметры для карточки
    let totalRunsCount: Int
    let totalDistanceString: String
    let chartData: [(id: Date, dayName: String, distance: Double)]

    // Максимальная высота столбиков
    private let maxChartDistance: Double = 10.0

    var body: some View {
        HStack(alignment: .center, spacing: 16) {

            // Левая текстовая панель
            VStack(alignment: .leading, spacing: 4) {
                Text("This week")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("\(totalRunsCount) runs")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.primary)

                Text(totalDistanceString)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)

            // Правая панель — график активности
          
            Chart {
                ForEach(chartData, id: \.dayName) { item in

                    // Светлый фон — полная высота столбика
                    BarMark(
                        x: .value("Day", item.dayName),
                        yStart: .value("Start", 0),
                        yEnd: .value("Max", maxChartDistance)
                    )
                    .foregroundStyle(Color.blue.opacity(0.08))
                    .cornerRadius(6)

                    // Синий прогресс — заполняется снизу вверх
                    if item.distance > 0 {
                        BarMark(
                            x: .value("Day", item.dayName),
                            yStart: .value("Start", 0),
                            yEnd: .value(
                                "Distance",
                                min(item.distance, maxChartDistance)
                            )
                        )
                        .foregroundStyle(Color.blue)
                        .cornerRadius(6)
                    }
                }
            }
            .chartYScale(domain: 0...maxChartDistance)
            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                    AxisValueLabel()
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .chartYAxis(.hidden)
            .chartLegend(.hidden)

            .frame( height: 85)
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

