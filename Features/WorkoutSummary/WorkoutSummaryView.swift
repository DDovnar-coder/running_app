import Foundation
import SwiftUI

struct WorkoutSummaryView: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel: WorkoutSummaryViewModel
    @State private var showDeleteConfirmation = false
    @FocusState private var isNoteFocused: Bool
    let name: String

    init(runRepository: RunRepository, name: String = "Just name", runID: UUID) {
        self.name = name
        _viewModel = State(initialValue: WorkoutSummaryViewModel(repository: runRepository, runID: runID))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 35) {
            HStack {
                HStack(spacing: 15) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.secondary)
                    VStack(alignment: .leading) {
                        Text(name)
                            .font(.headline)

                        if let period = viewModel.periodText {
                            Text(period)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                Spacer()
                Button(action: {
                    viewModel.saveRating()
                    router.pop()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.primary)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { isNoteFocused = false }

            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    if let run = viewModel.run {
                        WorkoutStatsCard(duration: run.duration, calories: run.calories)
                    }

                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            HStack(spacing: 6) {
                                Text("😐")
                                Text("workoutSummaryView.comfort.easy")
                            }
                            .font(.subheadline)
                            .foregroundColor(.gray)

                            Spacer()

                            HStack(spacing: 6) {
                                Text("workoutSummaryView.comfort.hard")
                                Text("🥵")
                            }
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        }

                        ComfortSlider(currentStep: $viewModel.currentStep, hasRated: $viewModel.hasRated)

                        Text("workoutSummaryView.user-feedback")
                            .font(.body)

                        FlowLayout(spacing: 8) {
                            ForEach(RunChip.allCases) { chip in
                                ChipView(
                                    title: chip.title,
                                    isSelected: viewModel.isSelected(chip),
                                    action: { viewModel.toggle(chip) }
                                )
                            }
                        }

                        NoteField(ownThought: $viewModel.ownThought, isNoteFocused: $isNoteFocused)

                        HStack {
                            Spacer()

                            if !isNoteFocused {
                                Button(action: { showDeleteConfirmation = true }) {
                                    HStack(spacing: 8) {
                                        Text("workoutSummaryView.delete.button")
                                            .fontWeight(.semibold)
                                        Image(systemName: "trash.fill")
                                            .font(.title3)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .foregroundStyle(.red)
                                .confirmationDialog(
                                    "workoutSummaryView.delete.confirm.title",
                                    isPresented: $showDeleteConfirmation,
                                    titleVisibility: .visible
                                ) {
                                    Button("workoutSummaryView.delete.confirmation.button", role: .destructive) {
                                        if viewModel.deleteRun() { router.pop() }
                                    }
                                    Button("workoutSummaryView.cancel.button", role: .cancel) { }
                                } message: {
                                    Text("workoutSummaryView.delete.confirm.message")
                                }
                            }
                            Spacer()
                        }
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture { isNoteFocused = false }
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .padding()
        .background(Color(hex: "F5F8F6"))
        .toolbar(.hidden, for: .navigationBar)
        .onDisappear { viewModel.saveRating() }
        .task { viewModel.load() }
    }
}

