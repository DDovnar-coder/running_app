import SwiftData
import Foundation

final class SwiftDataRunRepository: RunRepository {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func save(_ run: RunModel) throws {
        let record = Run(startDate: run.startDate, duration: run.duration, calories:  run.calories, comfort: run.calories, note: run.note)
        modelContext.insert(record)
        try modelContext.save()
    }
    
    func fetchAll() throws -> [RunModel] {
        let descriptor = FetchDescriptor<Run>(
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        let records = try modelContext.fetch(descriptor)
        return records.map{ RunModel(startDate: $0.startDate, duration: $0.duration, calories: $0.calories)
        }
    }
    
    func update(id: RunModel.ID, comfort: Int?, note: String?, chips: [String]) throws {
        
    }
    
    func fetch(id: RunModel.ID) throws -> RunModel? {
        return nil
    }
    
    func delete(id: RunModel.ID) throws {
//        let record = try modelContext.fetch(id: id)
//        modelContext.delete(record)
//        try modelContext.save()
    }
}
