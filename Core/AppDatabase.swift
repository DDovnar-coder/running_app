import Foundation
import GRDB

struct AppDatabase {
    let dbQueue: DatabaseQueue
    
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
                t.column("calories", .integer).notNull().defaults(to: 0)
            }
        }
        
        migrator.registerMigration("addUuidToRun") { db in
            try db.alter(table: "run") { t in
                t.add(column: "uuid", .text).notNull().defaults(to: "")
            }
        }
        
        migrator.registerMigration("v2_addComfortAndNote") { db in
            try db.alter(table: "run") { t in
                t.add(column: "comfort", .integer)
                t.add(column: "note", .text)
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
}


