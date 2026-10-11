import Foundation
import GRDB

struct RunRecord: Codable, FetchableRecord, PersistableRecord {
    var id: Int64?
    var uuid: UUID
    var startDate: Date
    var duration: TimeInterval
    var calories: Int
    var comfort: Int?
    var note: String?
    
    static let databaseTableName = "run"
}

extension RunRecord {
    init(model: RunModel) {
        id = nil
        uuid = model.id
        startDate = model.startDate
        duration = model.duration
        calories = model.calories
        comfort = model.comfort
        note = model.note
    }
}
