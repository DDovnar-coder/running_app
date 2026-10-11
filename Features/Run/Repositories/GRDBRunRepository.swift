import Foundation
import GRDB

final class GRDBRunRepository: RunRepository {
    private let database: AppDatabase
    
    init(database: AppDatabase = .shared) {
        self.database = database
    }
    
    func save(_ run: RunModel) throws {
        let record = RunRecord(model: run)
        
        try database.dbQueue.write { db in
            try record.insert(db)
        }
    }
    
    func fetchLatestRun() throws -> RunModel? {
        let record = try database.dbQueue.read { db in
            try RunRecord.order(Column("startDate").desc).fetchOne(db)
        }
        
//        return record.map { RunModel(id: $0.uuid, startDate: $0.startDate, duration: $0.duration, calories: $0.calories, comfort: $0.comfort, note: $0.note) }
        
        return record.map(RunModel.init(record:))
    }
    
    func fetchAll() throws -> [RunModel] {
        let records = try database.dbQueue.read { db in
            try RunRecord.order(Column("startDate").desc).fetchAll(db)
        }
        
//        return records.map { RunModel(id: $0.uuid, startDate: $0.startDate, duration: $0.duration, calories: $0.calories) }
        return records.map(RunModel.init(record:))
    }
    
    func update(id: RunModel.ID, comfort: Int?, note: String?) throws {
        try database.dbQueue.write { db in
           _ = try RunRecord
                .filter(Column("uuid") == id)
                .updateAll(db, [
                    Column("comfort").set(to: comfort),
                    Column("note").set(to: note)
                ])
        }
    }
    
    func delete(id: RunModel.ID) throws {
        try database.dbQueue.write { db in
            _ = try RunRecord.filter(Column("uuid") == id).deleteAll(db)
        }
    }
}
