import SwiftUI

enum AppDestination: Hashable {
    case workout
    case profile
}

@main
struct running_appApp: App {
    @AppStorage("should_show_welcome") private var showWelcome: Bool = true
    @AppStorage("has_completed_profile") private var hasCompletedProfile: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if showWelcome {
                WelcomeView(onContinue: { showWelcome = false })
            } else if !hasCompletedProfile {
                NavigationStack {
                    DataInputView(onContinue: { hasCompletedProfile = true })
                }
            } else {
                MainView()
            }
        }
    }
}
