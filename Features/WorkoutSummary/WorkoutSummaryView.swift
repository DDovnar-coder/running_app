import Foundation
import SwiftUI

enum EffortLevel: Int, CaseIterable {
    case easy = 1, moderate, hard, extreme
    
    var flameCount: Int { rawValue }
}

private let phrases = [
    "workoutSummaryView.note.lightLegs",
    "workoutSummaryView.note.hot",
    "workoutSummaryView.note.hardBreathing",
    "workoutSummaryView.note.wantedToStop",
    "workoutSummaryView.note.newPace",
    "workoutSummaryView.note.feltStrong",
    "workoutSummaryView.note.heavyLegs",
    "workoutSummaryView.note.sideStitch",
    "workoutSummaryView.note.greatWeather",
    "workoutSummaryView.note.littleSleep"
]

struct WorkoutSummaryView: View {
    @Environment(AppRouter.self) private var router
    @State private var run: RunModel?
    @State private var selectedEffort: EffortLevel?
    @State private var currentStep: Int = 0
    @State private var showDeleteConfirmation: Bool = false
    @State private var hasRated: Bool = false
    @State private var isDeleted: Bool = false
    @FocusState private var isNoteFocused: Bool
    var runRepository: RunRepository
    var name: String = "Just name"
    let totalSteps: Int = 4
    let stepLabels = ["x1", "x2", "x3", "x4"]
    let runID: UUID
    
    @State private var selectedChips: Set<String> = []
    @State private var ownThought = ""
    
    private var note: String? {
        let localizedPhrases = phrases
            .filter { selectedChips.contains($0) }
            .map { NSLocalizedString($0, comment: "") }
        
        let trimmedThought = ownThought.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var finalComponents = localizedPhrases
        if !trimmedThought.isEmpty {
            finalComponents.append(trimmedThought)
        }
        
        guard !finalComponents.isEmpty else { return nil }
        
        return finalComponents.joined(separator: ", ")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 35) {
            HStack {
                HStack(spacing: 15) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.secondary)
                    VStack(alignment: .leading) {
                        Text(
                            name
                        )
                        .font(.headline)
                        
                        if let run {
                            let endDate = run.startDate.addingTimeInterval(run.duration)
                            
                            Text("\(run.startDate.formatted(.dateTime.day().month().hour().minute())) — \(endDate.formatted(.dateTime.hour().minute()))")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                Spacer()
                Button(action: {
                    saveRating()
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
                    
                    VStack(alignment: .leading, spacing: 24) {
                        if let run {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("workoutSummaryView.data.workout")
                                    .font(.subheadline)
                                    .foregroundStyle(Color(hex: "89938D"))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(Duration.seconds(run.duration).formatted())")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color(hex: "202923"))
                                    
                                    Text("workoutSummaryView.data.timeRun")                           .font(.subheadline)
                                        .foregroundStyle(Color(hex: "89938D"))
                                }
                            }
                            
                            Divider()
                                .background(Color(hex: "89938D").opacity(0.2))
                            
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("5.24")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color(hex: "202923"))
                                    
                                    Text("км")
                                        .font(.caption)
                                        .foregroundStyle(Color(hex: "89938D"))
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("6:10")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color(hex: "202023"))
                                    
                                    Text("мин/км")
                                        .font(.caption)
                                        .foregroundStyle(Color(hex: "89938D"))
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("\(run.calories)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color(hex: "202923"))
                                    
                                    Text("workoutSummaryView.text.kcal")
                                        .font(.caption)
                                        .foregroundStyle(Color(hex: "89938D"))
                                }
                            }
                        }
                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(12)

                    
                    VStack(spacing: 20) {
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
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color(hex: "E9F0EB"))
                                    .frame(height: 44)
                                    .overlay(
                                        Capsule()
                                              .stroke(Color(hex: "C4C8C5"), lineWidth: 2)
                                    )
                                
                                HStack(spacing: 0) {
                                    ForEach(0..<totalSteps, id: \.self) { index in
                                        Text(stepLabels[index])
                                            .font(.system(.subheadline, design: .rounded))
                                            .fontWeight(.medium)
                                            .foregroundColor(currentStep == index ? .clear : Color(hex: "78847C"))
                                            .frame(width: geometry.size.width / CGFloat(totalSteps), height: 44)
                                    }
                                }
                                
                                let stepWidth = geometry.size.width / CGFloat(totalSteps)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "flame.fill")
                                    Text(stepLabels[currentStep])
                                }
                                .font(.system(.callout, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .frame(width: stepWidth - 4, height: 40)
                                .background(
                                    Capsule()
                                        .fill(Color(hex: "35C866"))
                                )
                                .padding(.leading, 2)
                                .offset(x: CGFloat(currentStep) * stepWidth)
                                .animation(.spring(response: 0.25, dampingFraction: 0.75), value: currentStep)
                            }
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        hasRated = true
                                        let locationX = value.location.x
                                        let progress = locationX / geometry.size.width
                                        let calculatedStep = Int((progress * CGFloat(totalSteps)).clamped(to: 0...CGFloat(totalSteps - 1)))
                                        if currentStep != calculatedStep {
                                            currentStep = calculatedStep
                                            triggerHapticFeedback()
                                        }
                                    }
                            )
                        }
                        .frame(height: 44)
                        
                        FlowLayout(spacing: 8) {
                            ForEach(phrases, id: \.self) { key in
                                ChipView(
                                    title: LocalizedStringKey(key),
                                    isSelected: selectedChips.contains(key),
                                    action: {
                                        if selectedChips.contains(key) {
                                            selectedChips.remove(key)
                                        } else {
                                            selectedChips.insert(key)
                                        }
                                    }
                                )
                            }
                        }
                        
                        
                        TextField("workoutSummaryView.note.placeholder", text: $ownThought,prompt: Text("workoutSummaryView.note.placeholder").foregroundStyle(Color.white.opacity(0.4)), axis: .vertical)
                            .lineLimit(1...4)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                            .cornerRadius(12)
                            .focused($isNoteFocused)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture { isNoteFocused = false }
                
            }
            .scrollBounceBehavior(.basedOnSize)
            
        }
        .safeAreaInset(edge: .bottom) {
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
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(.black)
                    .confirmationDialog(
                        "workoutSummaryView.delete.confirm.title",
                        isPresented: $showDeleteConfirmation,
                        titleVisibility: .visible,
                    ) {
                        Button("workoutSummaryView.delete.confirmation.button", role: .destructive) {
                            do {
                                guard let run else { return }
                                try runRepository.delete(id: run.id)
                                isDeleted = true
                                router.pop()
                            } catch {
                                print("delete failed:", error)
                            }
                        }
                        Button("workoutSummaryView.cancel.button", role: .cancel) { }
                    } message: {
                        Text("workoutSummaryView.delete.confirm.message")
                    }
                    
                }
                Spacer()
            }
        }
        .padding()
        .background(Color(hex: "F5F8F6"))
        .toolbar(.hidden, for: .navigationBar)
        .onDisappear{
            saveRating()
        }
        .task {
            do {
                self.run = try runRepository.fetchLatestRun()
            } catch {
                print("Failed to fetch latest run: \(error)")
            }
        }
        
        Spacer()
    }
    
    private func triggerHapticFeedback() {
        let impactMed = UIImpactFeedbackGenerator(style: .light)
        impactMed.impactOccurred()
    }
    
    private func saveRating() {
        guard !isDeleted else { return }
        do {
            try runRepository.update(id: runID, comfort: hasRated ? currentStep + 1 : nil, note: note)
        } catch {
            print("update failed:", error)
        }
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

