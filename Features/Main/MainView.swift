import SwiftUI
import SwiftData

struct MainView: View {
    @State private var showCountdown: Bool = false
    @State private var runs: [RunModel] = []
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
                            Text("\(run.startDate.formatted(.dateTime.day().month())) — \(Duration.seconds(run.duration).formatted())")
                                .listRowInsets(EdgeInsets())
                        }
                    } header: {
                        Text("MainView.history")
                            .font(.headline)
                            .padding(.bottom, 5)
                    }
                    
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
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
    }
}
