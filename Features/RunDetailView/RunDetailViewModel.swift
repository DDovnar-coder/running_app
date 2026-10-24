import SwiftUI

@Observable
final class RunDetailViewModel {
    private(set) var run: RunModel?
    private let runRepository: RunRepository
    private let runID: UUID
    
    init(runRepository: RunRepository, runID: UUID) {
        self.runRepository = runRepository
        self.runID = runID
    }
    
    var summaryText: String? {
        guard let run else { return nil }
        let date = run.startDate.formatted(.dateTime.day().month().hour().minute())
        return "\(date) — \(Duration.seconds(run.duration).formatted())"
    }
    
    func fetchRun() {
        do {
            self.run = try runRepository.fetch(id: runID)
        } catch {
            print("Failed to fetch run: \(error)")
        }
    }
}
