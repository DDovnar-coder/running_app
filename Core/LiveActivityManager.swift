import Foundation
import ActivityKit

final class LiveActivityManager {
    private var currentActivity: Activity<RunningAttributes>?
    
    func startWorkout(session: WorkoutSession) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        
        let attributes = RunningAttributes(startTime: session.startTime)
        let state = makeState(session: session, distance: 0, pace: "--:--", kcal: 0)
        let content = ActivityContent(state: state, staleDate: nil)
        
        do {
            currentActivity = try Activity.request(attributes: attributes, content: content)
        } catch {
            print("Не удалось запустить Live Activity: \(error.localizedDescription)")
            
        }
    }
    
    func restoreOrStart(session: WorkoutSession) {
        if let existing = Activity<RunningAttributes>.activities.first {
            currentActivity = existing
        } else {
            startWorkout(session: session)
        }
    }
    
    func updateWorkout(session: WorkoutSession, distance: Double, pace: String, kcal: Int) {
        let state = makeState(session: session, distance: distance, pace: pace, kcal: kcal)
        let content = ActivityContent(state: state, staleDate: nil)
        Task { await currentActivity?.update(content) }
    }
    
    func stopWorkout() {
        currentActivity = nil
        Task {
            for activity in Activity<RunningAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }
    }
    
    private func makeState(session: WorkoutSession, distance: Double, pace: String, kcal: Int)
    -> RunningAttributes.ContentState {
        RunningAttributes.ContentState(
            distance: distance,
            pace: pace,
            kcal: kcal,
            timerStart: session.timerStart,
            frozenElapsed: session.pausedAt != nil ? session.elapsed() : nil
        )
    }
}
