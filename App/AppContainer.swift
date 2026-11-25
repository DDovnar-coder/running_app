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
    private let workoutStore: WorkoutSessionStore
    private let healthStore: HealthService
    
    let router: AppRouter
    
    let defaults = UserDefaults.standard
    
    init(runRepository: RunRepository) {
        self.runRepository = runRepository
        self.liveActivityManager = LiveActivityManager()
        self.userDefaults = defaults
        self.workoutStore = WorkoutSessionStore(defaults: defaults)
        self.router = AppRouter(defaults: defaults)
        self.healthStore = HealthKitService()
    }
    
    func makeMainViewModel() -> MainViewModel {
        MainViewModel(repository: runRepository)
    }
    
    func makeProfileViewModel(mode: DataInputMode) -> DataInputViewModel {
        DataInputViewModel(
            mode: mode,
            defaults: userDefaults,
            healthService: healthStore
        )
    }
    
    func makeActiveWorkoutViewModel() -> ActiveWorkoutViewModel {
        ActiveWorkoutViewModel(repository: runRepository, defaults: userDefaults, liveActivityManager: liveActivityManager, store: workoutStore)
        
    }
    
    func makeWorkoutSummaryViewModel(runID: UUID) -> WorkoutSummaryViewModel {
        WorkoutSummaryViewModel(repository: runRepository, runID: runID)
    }
    
    func makeRunDetailViewModel(runID: UUID) -> RunDetailViewModel {
        RunDetailViewModel(runRepository: runRepository, runID: runID)
    }
    
    
    func openActiveWorkoutIfNeeded() {
        guard router.phase == .main,
              router.path.isEmpty,
              workoutStore.load() != nil else { return }
        router.push(.workout)
    }
}
