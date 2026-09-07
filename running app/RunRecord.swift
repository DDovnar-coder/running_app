import Foundation
import GRDB

struct RunRecord: Codable, FetchableRecord, PersistableRecord {
    var id: Int64?
    var startDate: Date
    var duration: TimeInterval
    
    static let databaseTableName = "run"
}
