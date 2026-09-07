import SwiftUI
import SwiftData

enum AppDestination: Hashable {
    case workout
    case profile
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
}


@main
struct running_appApp: App {
 
    @State private var router = AppRouter()
    
    var body: some Scene {
        WindowGroup {
          
            
            
            NavigationStack(path: $router.path) {
                switch router.phase {
                    case .welcome:
                        WelcomeView()
                    case .profileSetup:
                        DataInputView()
                    case .main:
                        MainView()
                }
            }
            .navigationDestination(for: AppDestination.self) { destination in
                switch destination {
                case .workout:
                    ActiveWorkoutView()
                case .profile:
                    DataInputView()
                }
            }
        }
        .environment(router)
        .modelContainer(for: Run.self)
    }
}
