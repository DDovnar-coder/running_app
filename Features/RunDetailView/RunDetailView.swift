import SwiftUI

struct RunDetailView: View {
    @State private var run: RunModel?
    let runRepository: RunRepository
    let runID: UUID
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let run {
                    Text("\(run.startDate.formatted(.dateTime.day().month().hour().minute())) — \(Duration.seconds(run.duration).formatted())")
                    
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
            do {
                self.run = try runRepository.fetch(id: runID)
            } catch {
                print("Failed to fetch run: \(error)")
            }
        }
    }
    
}

