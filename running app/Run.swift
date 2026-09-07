import SwiftUI
import Foundation
import SwiftData

@Model
final class Run{
    var startDate: Date
    var duration: TimeInterval
    
    init(startDate: Date, duration: TimeInterval) {
        self.startDate = startDate
        self.duration = duration
    }
    
}
