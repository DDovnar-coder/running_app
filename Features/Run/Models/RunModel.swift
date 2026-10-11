import GRDB
import SwiftData
import SwiftUI

struct RunModel: Identifiable {
    var id: UUID = UUID()
    var startDate: Date
    var duration: TimeInterval
    var calories: Int
    var comfort: Int?
    var note: String?
}

extension RunModel {
    nonisolated init(record: RunRecord) {
        id = record.uuid
        startDate = record.startDate
        duration = record.duration
        calories = record.calories
        comfort = record.comfort
        note = record.note
    }
}

