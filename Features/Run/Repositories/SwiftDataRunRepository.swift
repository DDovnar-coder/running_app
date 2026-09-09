import SwiftData
import Foundation

final class SwiftDataRunRepository: RunRepository {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func save(_ run: RunModel) throws {
        let record = Run(startDate: run.startDate, duration: run.duration)
        modelContext.insert(record)
        try modelContext.save()
    }
    
    func fetchAll() throws -> [RunModel] {
        let descriptor = FetchDescriptor<Run>(
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        let records = try modelContext.fetch(descriptor)
        return records.map{ RunModel(startDate: $0.startDate, duration: $0.duration)
        }
    }
}
