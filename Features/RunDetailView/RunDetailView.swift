import SwiftUI

struct RunDetailView: View {
    @Bindable var viewModel: RunDetailViewModel
    @FocusState private var isNoteFocused: Bool
    
    init(viewModel: RunDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let run = viewModel.run {
                    WorkoutStatsCard(duration: run.duration, calories: run.calories)
                    
                    sliderSection(run: run)
                    
                    chipsSection
                    
                    noteSection
                }
            }
        }
        .toolbar {
            if viewModel.isEditing {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { viewModel.cancelEditing() }) {
                        Image(systemName: "xmark")
                    }
                }
            }
            ToolbarItem(placement: .principal) {
                if let text = viewModel.summaryText {
                    Text(text)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.primary)
                }
                    
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if viewModel.isEditing {
                        viewModel.save()
                    } else {
                        viewModel.startEditing()
                    }
                }) {
                    Image(systemName: viewModel.isEditing ? "checkmark" : "pencil")
                }
            }
        }
        .navigationBarBackButtonHidden(viewModel.isEditing)
        
        .contentShape(Rectangle())
        .onTapGesture { isNoteFocused = false }
        .padding()
        .background(Color(hex: "F5F8F6"))
        
        
        .task {
            viewModel.fetchRun()
        }
    }
    
    @ViewBuilder
    private func sliderSection(run: RunModel) -> some View {
        if viewModel.isEditing {
            ComfortSlider(
                currentStep: $viewModel.currentStep,
                hasRated: $viewModel.hasRated
            )
        } else if run.comfort != nil {
            ComfortSlider(
                currentStep: .constant(viewModel.savedStep),
                hasRated: .constant(true),
                isInteractive: false
            )
        }
    }
    
    @ViewBuilder
    private var chipsSection: some View {
        if viewModel.isEditing {
            FlowLayout(spacing: 8) {
                ForEach(RunChip.allCases) { chip in
                    ChipView(
                        title: chip.title,
                        isSelected: viewModel.selectedChips.contains(chip),
                        action: {
                            viewModel.toggle(chip)
                        }
                    )
                }
            }
        } else if !viewModel.savedChips.isEmpty {
            FlowLayout(spacing: 8) {
                ForEach(viewModel.savedChips) { chip in
                    ChipLabel(title: chip.title, style: .archival)
                }
            }
        }
    }
    
    @ViewBuilder
    private var noteSection: some View {
        if viewModel.isEditing {
            NoteField(
                ownThought: $viewModel.ownThought,
                isNoteFocused: $isNoteFocused,
            )
        } else if let note = viewModel.run?.note {
            NoteCard {
                Text(note)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}


