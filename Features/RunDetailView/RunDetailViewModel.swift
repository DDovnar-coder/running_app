import SwiftUI

@Observable
final class RunDetailViewModel {
    private(set) var run: RunModel?
    private let runRepository: RunRepository
    private let runID: UUID
    
    var isEditing = false
    var currentStep = 0
    var hasRated = false
    var selectedChips: Set<RunChip> = []
    var ownThought = ""
    
    init(runRepository: RunRepository, runID: UUID) {
        self.runRepository = runRepository
        self.runID = runID
    }
    
    var summaryText: String? {
        guard let run else { return nil }
        let date = run.startDate.formatted(.dateTime.day().month().hour().minute())
        return "\(date) — \(Duration.seconds(run.duration).formatted())"
    }
    
    var savedStep: Int {
        guard let comfort = run?.comfort else { return 0 }
        return min(max(comfort - 1, 0), 3)
    }
    
    var savedChips: [RunChip] {
        run?.chips.compactMap(RunChip.init(rawValue:)) ?? []
    }
    
    func startEditing() {
        guard let run else { return }
        
        hasRated = run.comfort != nil
        currentStep = savedStep
        
        selectedChips = Set(run.chips.compactMap(RunChip.init(rawValue:)))

        ownThought = run.note ?? ""

        isEditing = true
    }
    
    func cancelEditing() {
        isEditing = false
    }
    
    func save() {
        let comfort: Int? = hasRated ? currentStep + 1 : nil
        
        let chips: [String] = RunChip.allCases
            .filter { selectedChips.contains($0) }
            .map(\.rawValue)
        
        let trimmedNote = ownThought.trimmingCharacters(in: .whitespacesAndNewlines)
        let note: String? = trimmedNote.isEmpty ? nil : trimmedNote
        
        do {
            try runRepository.update(id: runID, comfort: comfort, note: note, chips: chips)
            fetchRun()
            isEditing = false
        } catch {
            print("Failed to save run: \(error)")
        }
    }
    
    func toggle(_ chip: RunChip) {
        if selectedChips.contains(chip) {
            selectedChips.remove(chip)
        } else {
            selectedChips.insert(chip)
        }
    }
    
    func fetchRun() {
        do {
            self.run = try runRepository.fetch(id: runID)
        } catch {
            print("Failed to fetch run: \(error)")
        }
    }
}
