import SwiftUI
import SwiftData

import SwiftUI

struct MainView: View {
    @State private var viewModel: MainViewModel
    @State private var showCountdown = false
    @Environment(AppRouter.self) private var router
    
    init(runRepository: RunRepository) {
        _viewModel = State(initialValue: MainViewModel(repository: runRepository))
    }
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .top) {
                Text("mainview.main-title")
                    .font(.title)
                    .fontWeight(.medium)
                
                Spacer()
                
                Button {
                    router.push(.profile)
                } label: {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 28))
                        .foregroundStyle(.tint)
                        .frame(width: 44, height: 44)
                }
            }
            
            StatsSummaryCard(
                count: viewModel.runs.count,
                totalDuration: viewModel.totalDuration
            )
            
            Button(action: { showCountdown = true }) {
                HStack(spacing: 5) {
                    Image(systemName: "figure.run")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.white)
                    Text("MainView.workout")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.extraLarge)
            .fullScreenCover(isPresented: $showCountdown) {
                CountdownView(onFinished: {
                    showCountdown = false
                    router.push(.workout)
                })
            } 
            
            if viewModel.isEmpty {
                Spacer()
                Text("mainview.noHistory")
                    .font(.body)
                    .frame(maxWidth: .infinity)
                Spacer()
            } else {
                VStack(alignment: .leading) {
                    Text("MainView.history")
                        .font(.headline)
                        .padding(.top, 15)
                        .padding(.bottom, 5)
                    List {
                        Section {
                            ForEach(viewModel.runs) { run in
                                VStack {
                                    RecentRunsView(
                                        dateTrainingRun: viewModel.dateText(for: run),
                                        timeTrainingRun: viewModel.durationText(for: run),
                                        action: { router.push(.runDetail(id: run.id)) }
                                    )
                                    Divider()
                                }
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets())
                                .padding(.horizontal, 15)
                            }
                            .onDelete { viewModel.requestDelete(at: $0) }
                        }
                    }
                    .cornerRadius(12)
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .confirmationDialog(
                        "mainview.delete.title",
                        isPresented: Binding(
                            get: { viewModel.runToDelete != nil },
                            set: { if !$0 { viewModel.runToDelete = nil } }
                        ),
                        titleVisibility: .visible,
                        presenting: viewModel.runToDelete
                    ) { run in
                        Button("run.delete.confirm", role: .destructive) {
                            viewModel.confirmDelete(run)
                        }
                        Button("run.delete.cancel", role: .cancel) { }
                    }
                    
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 20)
        .background(Color(hex: "F5F8F6"))
        .onAppear { viewModel.loadRuns() }
    }
}

