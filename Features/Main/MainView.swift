import SwiftUI
import SwiftData

struct MainView: View {
    @State private var showCountdown: Bool = false
    @State private var runs: [RunModel] = []
    @State private var runToDelete: RunModel?
    @Environment(\.modelContext) private var modelContext
    @Environment(AppRouter.self) private var router
    
    let runRepository: RunRepository
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {showCountdown = true}) {
                Text("MainView.workout")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .fullScreenCover(isPresented: $showCountdown) {
                CountdownView(onFinished: {
                    showCountdown = false
                    router.push(.workout)
                })
            }
            
            StatsSummaryCard(
                count: runs.count,
                totalDuration: runs.reduce(0) { $0 + $1.duration}
            )
            
            if (runs.isEmpty) {
                Spacer()
                Text("mainview.noHistory")
                    .font(.body)
                    .frame(maxWidth: .infinity)
                Spacer()
                
            } else {
                List {
                    Section {
                        ForEach(runs) { run in
                            VStack {
                                RecentRunsView(dateTrainingRun: "\(run.startDate.formatted(.dateTime.day().month().hour().minute()))", timeTrainingRun: "\(Duration.seconds(run.duration).formatted())",
                                               action: { router.push(.runDetail(id: run.id)) })
                                
                                Divider()
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                        }
                        .onDelete{ indexSet in
                            if let index = indexSet.first {
                                runToDelete = runs[index]
                            }
                            
                        }
                    } header: {
                        Text("MainView.history")
                            .font(.headline)
                            .padding(.bottom, 5)
                    }
                    
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .confirmationDialog(
                    "mainview.delete.title",
                    isPresented: Binding(
                        get: { runToDelete != nil },
                        set: { isShown in
                            if !isShown {
                                runToDelete = nil
                            }
                        }
                    ),
                    titleVisibility: .visible,
                    presenting: runToDelete
                ) { run in
                    Button("run.delete.confirm", role: .destructive) {
                        do {
                            try runRepository.delete(id: run.id)
                            loadRuns()
                        } catch {
                            print(error)
                        }
                    }
                    Button("run.delete.cancel", role: .cancel) { }
                }
                
            }
            
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 20)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { router.push(.profile) }) {
                    Image(systemName: "person.crop.circle")
                        .foregroundStyle(.tint)
                }
            }
        }
        .onAppear() {
            loadRuns()
        }
    }
    
    
    private func loadRuns() {
        runs = (try? runRepository.fetchAll()) ?? []
        print(runs.map(\.comfort))
        print(runs.map(\.chips))
        print(runs.map(\.note))
    }
}
