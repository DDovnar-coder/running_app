import ActivityKit
import SwiftUI

struct RunningAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        var distance: Double
        var pace: String
        var kcal: Int
    }
    
    var startTime: Date
}
