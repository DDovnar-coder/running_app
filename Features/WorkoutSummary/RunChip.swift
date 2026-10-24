import SwiftUI

enum RunChip: String, CaseIterable, Identifiable {
    case lightLegs     = "workoutSummaryView.note.lightLegs"
    case hot           = "workoutSummaryView.note.hot"
    case hardBreathing = "workoutSummaryView.note.hardBreathing"
    case wantedToStop  = "workoutSummaryView.note.wantedToStop"
    case newPace       = "workoutSummaryView.note.newPace"
    case feltStrong    = "workoutSummaryView.note.feltStrong"
    case heavyLegs     = "workoutSummaryView.note.heavyLegs"
    case sideStitch    = "workoutSummaryView.note.sideStitch"
    case greatWeather  = "workoutSummaryView.note.greatWeather"
    case littleSleep   = "workoutSummaryView.note.littleSleep"
    
    var id: String { rawValue }
    var title: LocalizedStringKey { LocalizedStringKey(rawValue) }
}
