import SwiftUI


struct MainView: View {
    @State private var path = NavigationPath()
    @State private var showCountdown: Bool = false
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button("Профиль") {
                    path = NavigationPath([AppDestination.profile])
                }
                
                Button("Начать тренировку") {
                    showCountdown = true
                }
                .fullScreenCover(isPresented: $showCountdown) {
                    CountdownView(onFinished: {
                        showCountdown = false
                        
                        path.append(AppDestination.workout)
                    })
                }
                
            }
            .navigationDestination(for: AppDestination.self) { dest in
                switch(dest) {
                case .workout: ActiveWorkoutView()
                case .profile: DataInputView(onContinue: { path.removeLast() })
                }
            }
        }
    }
}
