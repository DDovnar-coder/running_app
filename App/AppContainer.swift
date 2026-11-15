import SwiftUI

@Observable
@MainActor
final class AppRouter {
    var path = NavigationPath()
    
    var phase: AppPhase {
        didSet {
            defaults.set(phase.rawValue, forKey: "appPhase")
        }
    }
    
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
        
        if let raw = UserDefaults.standard.string(forKey: "appPhase"),
           let saved = AppPhase(rawValue: raw) {
            phase = saved
        } else {
            phase = .welcome
        }
    }
    
    func completeWelcome() {
        phase = .profileSetup
    }
    
    func completeProfile() {
        phase = .main
    }
    
    func push(_ destination: AppDestination) {
        path.append(destination)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}


@MainActor
final class AppContainer {
    private let runRepository: RunRepository
    private let liveActivityManager: LiveActivityManager
    private let userDefaults: UserDefaults
    
    let router: AppRouter
    
    init(runRepository: RunRepository) {
        self.runRepository = runRepository
        self.liveActivityManager = LiveActivityManager()
        self.userDefaults = .standard
        self.router = AppRouter(defaults: .standard)
    }
    
    func makeMainViewModel() -> MainViewModel {
        MainViewModel(repository: runRepository)
    }
    
    func makeProfileViewModel(mode: DataInputMode) -> DataInputViewModel {
        DataInputViewModel(
            mode: mode,
            defaults: userDefaults
        )
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
