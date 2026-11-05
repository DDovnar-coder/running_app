import SwiftUI
import SwiftData

enum AppDestination: Hashable {
    case workout
    case profile
    case summary(id: UUID)
    case runDetail(id: UUID)
}

enum AppPhase: String, Hashable {
    case welcome
    case profileSetup
    case main
}

@Observable
final class AppRouter {
    var path = NavigationPath()
    var phase: AppPhase {
        didSet {
            UserDefaults.standard.set(phase.rawValue, forKey: "appPhase")
        }
    }
    
    init() {
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


@main
struct running_appApp: App {
    @State private var router = AppRouter()
    
    private let container = AppContainer(
        runRepository: GRDBRunRepository(database: .shared)
    )
    
    //    let runRepository: RunRepository
    //    let modelContainer: ModelContainer
    
    //    init() {
    //        let container = try! ModelContainer(for: Run.self)
    //        self.modelContainer = container
    //        self.runRepository = SwiftDataRunRepository(modelContext: container.mainContext)
    //    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                Group {
                    switch router.phase {
                    case .welcome:
                        WelcomeView()
                    case .profileSetup:
                        DataInputView(mode: .onboarding)
                    case .main:
                        MainView(viewModel: container.makeMainViewModel())
                    }
                    
                }
                .navigationDestination(for: AppDestination.self) { destination in
                    switch destination {
                    case .workout:
                        ActiveWorkoutView(viewModel: container.makeActiveWorkoutViewModel())
                    case .profile:
                        DataInputView(mode: .edit)
                    case .summary(let id):
                        WorkoutSummaryView(viewModel: container.makeWorkoutSummaryViewModel(runID: id))
                    case .runDetail(let id):
                        RunDetailView(viewModel: container.makeRunDetailViewModel(runID: id))
                    }
                    
                }
            }
        }
        .environment(router)
    }
}
