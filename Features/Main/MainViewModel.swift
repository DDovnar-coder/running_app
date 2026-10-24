import SwiftUI

@Observable
final class MainViewModel {
    private(set) var runs: [RunModel] = []
    var runToDelete: RunModel?

    private let repository: RunRepository

    init(repository: RunRepository) {
        self.repository = repository
    }

    // MARK: - Состояние для отображения

    var isEmpty: Bool { runs.isEmpty }

    var totalDuration: TimeInterval {
        runs.reduce(0) { $0 + $1.duration }
    }

    func dateText(for run: RunModel) -> String {
        run.startDate.formatted(.dateTime.day().month().hour().minute())
    }

    func durationText(for run: RunModel) -> String {
        Duration.seconds(run.duration).formatted()
    }

    // MARK: - Действия

    func loadRuns() {
        runs = (try? repository.fetchAll()) ?? []
    }

    func requestDelete(at offsets: IndexSet) {
        if let index = offsets.first {
            runToDelete = runs[index]
        }
    }
    
    func confirmDelete(_ run: RunModel) {
        do {
            try repository.delete(id: run.id)
            loadRuns()
        } catch {
            print(error)
        }
    }
}
