import GRDB
import SwiftData
import SwiftUI

struct RunModel: Identifiable {
    var id: UUID = UUID()
    var startDate: Date
    var duration: TimeInterval
}
