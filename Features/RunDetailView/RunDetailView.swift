import SwiftUI

struct RunDetailView: View {
    @State private var viewModel: RunDetailViewModel
    
    init(runRepository: RunRepository, runID: UUID) {
        _viewModel = State(initialValue: RunDetailViewModel(runRepository: runRepository, runID: runID))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let run = viewModel.run {
                    if let text = viewModel.summaryText { Text(text) }
                    
                    WorkoutStatsCard(duration: run.duration, calories: run.calories)
                    
                    if let comfort = run.comfort {
                        ComfortSlider(
                            currentStep: .constant(comfort - 1),
                            hasRated: .constant(true),
                            isInteractive: false
                        )
                    }
                    
                    if !run.chips.isEmpty {
                        FlowLayout(spacing: 8) {
                            ForEach(run.chips, id: \.self) { key in
                                ChipLabel(title: LocalizedStringKey(key), style: .archival)
                            }
                        }
                    }
                    
                    if let note = run.note {
                        NoteCard {
                            Text(note)
                                .font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(hex: "F5F8F6"))
        
        .task {
            viewModel.fetchRun()
        }
    }
    
}

