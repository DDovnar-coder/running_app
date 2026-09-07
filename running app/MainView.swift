import SwiftUI
import SwiftData


struct MainView: View {
    //    @Query(sort: \Run.startDate, order: .reverse) private var runs: [Run]
    @State private var path = NavigationPath()
    @State private var showCountdown: Bool = false
    @State private var runs: [RunModel] = []
    @Environment(\.modelContext) private var modelContext
    
    private var repository: RunRepository {
//        SwiftDataRunRepository(modelContext: modelContext)
        GRDBRunRepository(database: AppDatabase.shared)
    }
    
    var body: some View {
//        NavigationStack(path: $path) {
            VStack {
                Button("MainView.profile") {
                    path = NavigationPath([AppDestination.profile])
                }
                
                Button("MainView.workout") {
                    showCountdown = true
                }
                .fullScreenCover(isPresented: $showCountdown) {
                    CountdownView(onFinished: {
                        showCountdown = false
                        
                        path.append(AppDestination.workout)
                    })
                }
                
                List(runs) { run in
                    Text("\(run.startDate.formatted()) — \(Int(run.duration))s")
                }
                
            }
//            .navigationDestination(for: AppDestination.self) { dest in
//                switch(dest) {
//                case .workout: ActiveWorkoutView()
//                case .profile: DataInputView(onContinue: { path.removeLast() })
//                }
//            }
            .onAppear() {
                loadRuns()
            }
//        }
    }
    
    private func loadRuns() {
        runs = (try? repository.fetchAll()) ?? []
    }
}
