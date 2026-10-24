import SwiftUI

@Observable
final class WorkoutSummaryViewModel {
    private(set) var run: RunModel?
    private(set) var isDeleted = false

    var currentStep = 0
    var hasRated = false
    var ownThought = ""

    private var selectedChips: Set<RunChip> = []

    private let repository: RunRepository
    private let runID: UUID

    init(repository: RunRepository, runID: UUID) {
        self.repository = repository
        self.runID = runID
    }

    // MARK: - Состояние для отображения

    var periodText: String? {
        guard let run else { return nil }
        let endDate = run.startDate.addingTimeInterval(run.duration)
        let start = run.startDate.formatted(.dateTime.day().month().hour().minute())
        let end = endDate.formatted(.dateTime.hour().minute())
        return "\(start) — \(end)"
    }

    func isSelected(_ chip: RunChip) -> Bool {
        selectedChips.contains(chip)
    }

    // MARK: - Действия

    func toggle(_ chip: RunChip) {
        if selectedChips.contains(chip) {
            selectedChips.remove(chip)
        } else {
            selectedChips.insert(chip)
        }
    }

    func load() {
        do {
            run = try repository.fetch(id: runID)
        } catch {
            print("Failed to fetch latest run: \(error)")
        }
    }

    func saveRating() {
        guard !isDeleted else { return }
        do {
            try repository.update(
                id: runID,
                comfort: hasRated ? currentStep + 1 : nil,
                note: note,
                chips: selectedChipKeys
            )
        } catch {
            print("update failed:", error)
        }
    }

    /// Возвращает true, если забег удалён и можно уходить с экрана
    func deleteRun() -> Bool {
        do {
            try repository.delete(id: runID)
            isDeleted = true
            return true
        } catch {
            print("delete failed:", error)
            return false
        }
    }

    // MARK: - Приватное

    private var selectedChipKeys: [String] {
        RunChip.allCases.filter { selectedChips.contains($0) }.map(\.rawValue)
    }

    private var note: String? {
        let trimmed = ownThought.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
