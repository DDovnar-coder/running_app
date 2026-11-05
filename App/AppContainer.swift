import SwiftUI

@MainActor
final class AppContainer {
    private let runRepository: RunRepository
    
    init(runRepository: RunRepository) {
        self.runRepository = runRepository
    }
    
    func makeMainViewModel() -> MainViewModel {
        MainViewModel(repository: runRepository)
    }
    
    func makeActiveWorkoutViewModel() -> ActiveWorkoutViewModel {
        ActiveWorkoutViewModel(repository: runRepository)
    }
    
    func makeWorkoutSummaryViewModel(runID: UUID) -> WorkoutSummaryViewModel {
        WorkoutSummaryViewModel(repository: runRepository, runID: runID)
    }
    
    func makeRunDetailViewModel(runID: UUID) -> RunDetailViewModel {
        RunDetailViewModel(runRepository: runRepository, runID: runID)
    }
}
