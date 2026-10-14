import SwiftUI
import Foundation
import SwiftData

@Model
final class Run{
    var startDate: Date
    var duration: TimeInterval
    var calories: Int
    var comfort: Int?
    var note: String?
    
    
    init(startDate: Date, duration: TimeInterval, calories: Int, comfort: Int?, note: String?) {
        self.startDate = startDate
        self.duration = duration
        self.calories = calories
        self.comfort = comfort
        self.note = note
    }
    
}
