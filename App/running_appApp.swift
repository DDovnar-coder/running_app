import SwiftUI

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

@main
struct running_appApp: App {
    private let container: AppContainer
    
    @State private var router: AppRouter

    init() {
        let container = AppContainer(
            runRepository: GRDBRunRepository(database: .shared)
        )
        
        self.container = container
        _router = State(initialValue: container.router)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                ZStack {
                    switch router.phase {
                    case .welcome:
                        WelcomeView()
                    case .profileSetup:
                        DataInputView(viewModel: container.makeProfileViewModel(mode: .onboarding))
                    case .main:
                        MainView(viewModel: container.makeMainViewModel())
                    }
                    
                }
                .navigationDestination(for: AppDestination.self) { destination in
                    switch destination {
                    case .workout:
                        ActiveWorkoutView(viewModel: container.makeActiveWorkoutViewModel())
                    case .profile:
                        DataInputView(viewModel: container.makeProfileViewModel(mode: .edit))
                    case .summary(let id):
                        WorkoutSummaryView(viewModel: container.makeWorkoutSummaryViewModel(runID: id))
                    case .runDetail(let id):
                        RunDetailView(viewModel: container.makeRunDetailViewModel(runID: id))
                    }
                    
                }
            }
            .task {
                container.openActiveWorkoutIfNeeded()
            }
        }
        .environment(router)
    }
}
