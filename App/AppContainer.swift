import SwiftUI

@MainActor
final class AppContainer {
    private let runRepository: RunRepository
    private let liveActivityManager: LiveActivityManager
    
    init(runRepository: RunRepository) {
        self.runRepository = runRepository
        self.liveActivityManager = LiveActivityManager()
    }
    
    func makeMainViewModel() -> MainViewModel {
        MainViewModel(repository: runRepository)
    }
    
    func makeActiveWorkoutViewModel() -> ActiveWorkoutViewModel {
        ActiveWorkoutViewModel(repository: runRepository, liveActivityManager: liveActivityManager)
    }
    
    func makeWorkoutSummaryViewModel(runID: UUID) -> WorkoutSummaryViewModel {
        WorkoutSummaryViewModel(repository: runRepository, runID: runID)
    }
    
    func makeRunDetailViewModel(runID: UUID) -> RunDetailViewModel {
        RunDetailViewModel(runRepository: runRepository, runID: runID)
    }
}
