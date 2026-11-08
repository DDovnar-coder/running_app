import Foundation
import ActivityKit

final class LiveActivityManager {
    private var currentActivity: Activity<RunningAttributes>?
    
    func startWorkout() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        
        let attributes = RunningAttributes(startTime: Date())
        
        let initialState = RunningAttributes.ContentState(distance: 0.0, pace: "--:--", kcal: 0)
        
        do {
            let content = ActivityContent(state: initialState, staleDate: nil)
            
            currentActivity = try Activity.request(attributes: attributes, content: content)
        } catch {
            print("Не удалось запустить Live Activity: \(error.localizedDescription)")

        }
    }
    
    func updateWorkout(distance: Double, pace: String, kcal: Int) {
        let updatedState = RunningAttributes.ContentState(distance: distance, pace: pace, kcal: kcal)
        let content = ActivityContent(state: updatedState, staleDate: nil)
        
        Task {
            await currentActivity?.update(content)
        }
    }
    
    func stopWorkout() {
          Task {
              await currentActivity?.end(nil, dismissalPolicy: .immediate)
              currentActivity = nil
          }
      }
}
