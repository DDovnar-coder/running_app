import SwiftUI

struct WorkoutStatsCard: View {
    let duration: TimeInterval
    let calories: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text("workoutSummaryView.data.workout")
                    .font(.subheadline)
                    .foregroundStyle(Color(hex: "89938D"))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(Duration.seconds(duration).formatted())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: "202923"))
                    
                    Text("workoutSummaryView.data.timeRun")                           .font(.subheadline)
                        .foregroundStyle(Color(hex: "89938D"))
                }
            }
            
            Divider()
                .background(Color(hex: "89938D").opacity(0.2))
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 12) {
                    // TODO: placeholder until GPS
                    Text("-")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: "202923"))
                    
                    Text("км")
                        .font(.caption)
                        .foregroundStyle(Color(hex: "89938D"))
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 12) {
                    // TODO: placeholder until GPS
                    Text("-")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(hex: "202023"))
                    
                    Text("мин/км")
                        .font(.caption)
                        .foregroundStyle(Color(hex: "89938D"))
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("\(calories)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: "202923"))
                    
                    Text("workoutSummaryView.data.calories")
                        .font(.caption)
                        .foregroundStyle(Color(hex: "89938D"))
                }
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(
            color: Color(red: 0.15, green: 0.25, blue: 0.20).opacity(0.08),
            radius: 14,
            x: 0,
            y: 3
        )
    }
}
