import Foundation
import GRDB

final class GRDBRunRepository: RunRepository {
    private let database: AppDatabase
    
    init(database: AppDatabase = .shared) {
        self.database = database
    }
    
    func save(_ run: RunModel) throws {
        let record = RunRecord(id: nil, startDate: run.startDate, duration: run.duration)
        try database.saveRun(record)
    }
    
    func fetchAll() throws -> [RunModel] {
        let records = try database.fetchAllRuns()
        return records.map { RunModel(startDate: $0.startDate, duration: $0.duration) }
    }
}
