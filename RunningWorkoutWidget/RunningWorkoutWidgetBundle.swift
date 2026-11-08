//
//  RunningWorkoutWidgetBundle.swift
//  RunningWorkoutWidget
//
//  Created by DDovnar on 07.11.2026.
//

import WidgetKit
import SwiftUI

@main
struct RunningWorkoutWidgetBundle: WidgetBundle {
    var body: some Widget {
        RunningWorkoutWidget()
        RunningWorkoutWidgetControl()
        RunningWorkoutWidgetLiveActivity()
    }
}
