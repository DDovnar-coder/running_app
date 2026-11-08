//
//  RunningWorkoutWidgetLiveActivity.swift
//  RunningWorkoutWidget
//
//  Created by DDovnar on 07.11.2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct RunningWorkoutWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct RunningWorkoutWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RunningWorkoutWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension RunningWorkoutWidgetAttributes {
    fileprivate static var preview: RunningWorkoutWidgetAttributes {
        RunningWorkoutWidgetAttributes(name: "World")
    }
}

extension RunningWorkoutWidgetAttributes.ContentState {
    fileprivate static var smiley: RunningWorkoutWidgetAttributes.ContentState {
        RunningWorkoutWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: RunningWorkoutWidgetAttributes.ContentState {
         RunningWorkoutWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: RunningWorkoutWidgetAttributes.preview) {
   RunningWorkoutWidgetLiveActivity()
} contentStates: {
    RunningWorkoutWidgetAttributes.ContentState.smiley
    RunningWorkoutWidgetAttributes.ContentState.starEyes
}
