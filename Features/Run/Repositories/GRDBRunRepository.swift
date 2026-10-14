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
    
    func fetch(id: RunModel.ID) throws -> RunModel? {
        let record = try database.dbQueue.read { db in
            try RunRecord.filter(Column("uuid") == id).fetchOne(db)
        }
        
        return record.map(RunModel.init(record:))
    }
    
    func fetchAll() throws -> [RunModel] {
        let records = try database.dbQueue.read { db in
            try RunRecord.order(Column("startDate").desc).fetchAll(db)
        }
        
        return records.map(RunModel.init(record:))
    }
    
    func update(id: RunModel.ID, comfort: Int?, note: String?, chips: [String]) throws {
        try database.dbQueue.write { db in
            guard var record = try RunRecord.filter(Column("uuid") == id).fetchOne(db) else { return }
            record.comfort = comfort
            record.chips = chips
            record.note = note
            try record.update(db)
        }
    }
    
    func delete(id: RunModel.ID) throws {
        try database.dbQueue.write { db in
            _ = try RunRecord.filter(Column("uuid") == id).deleteAll(db)
        }
    }
}
