import SwiftUI

struct WorkoutSession: Codable {
    let startTime: Date
    var pausedAt: Date?
    var totalPausedDuration: TimeInterval = 0
    
    var timerStart: Date {
        startTime.addingTimeInterval(totalPausedDuration)
    }
    
    func elapsed(at now: Date = .now) -> TimeInterval {
        let end = pausedAt ?? now
        
        return end.timeIntervalSince(startTime) - totalPausedDuration
    }
    
    mutating func pause(at now: Date = .now) {
        guard pausedAt == nil else { return }
        pausedAt = now
    }
    
    mutating func resume(at now: Date = .now) {
        guard let pausedAt else { return }
        totalPausedDuration += now.timeIntervalSince(pausedAt)
        self.pausedAt = nil
    }
}
