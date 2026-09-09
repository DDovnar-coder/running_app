import Foundation
import GRDB

struct AppDatabase {
    private let dbQueue: DatabaseQueue
    
    init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
        try? migrator.migrate(dbQueue)
    }
    
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("createRun") { db in
            try db.create(table: "run") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("startDate", .datetime).notNull()
                t.column("duration", .double).notNull()
            }
        }
        
        return migrator
    }
}

extension AppDatabase {
    private static func makeShared() -> AppDatabase {
        let fileManager = FileManager.default
        let folderUrl = try! fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let dbURL = folderUrl.appendingPathComponent("db.sqlite")
        
        let dbQueue = try! DatabaseQueue(path: dbURL.path)
        
        return AppDatabase(dbQueue: dbQueue)
        
    }
    
    static let shared = AppDatabase.makeShared()
    
    func saveRun(_ run: RunRecord) throws {
        try dbQueue.write { db in
            let mutableRun = run
            try mutableRun.insert(db)
        }
    }
    
    func fetchAllRuns() throws -> [RunRecord] {
        try dbQueue.read { db in
            try RunRecord.order(Column("startDate").desc).fetchAll(db)
        }
    }
}


