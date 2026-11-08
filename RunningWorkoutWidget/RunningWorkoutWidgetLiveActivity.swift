import WidgetKit
import SwiftUI

struct RunningWorkoutWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RunningAttributes.self) { context in
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text("liveActivity.activeWorkout")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(context.attributes.startTime, style: .timer)
                        .font(.title)
                        .bold()
                        .foregroundStyle(.blue)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    
                    Text("liveActivity.distance \(context.state.distance, specifier: "%.2f")")
                        .font(.title2)
                        .bold()
                    
                    Text("liveActivity.pace \(context.state.pace)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "figure.run")
                        .font(.title)
                        .padding(.leading, 8)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.attributes.startTime, style: .timer)
                        .font(.title3)
                        .foregroundStyle(.blue)
                        .offset(x: 57)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Text("liveActivity.distance \(context.state.distance, specifier: "%.2f")")
                            .bold()
                        
                        Spacer()
                        
                        Text("liveActivity.calories \(context.state.kcal)")
                    }
                    .padding(.horizontal, 10)
                    
                }
                
            } compactLeading: {
                Image(systemName: "figure.run")
            } compactTrailing: {
                Text(context.attributes.startTime, style: .timer)
                    .offset(x: 57)
                    .foregroundStyle(.blue)
            } minimal: {
                Image(systemName: "figure.run")
            }
        }
    }
}
