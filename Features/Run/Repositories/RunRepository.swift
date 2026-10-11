
import Foundation

protocol RunRepository {
    func save(_ run: RunModel) throws
    func fetchLatestRun() throws -> RunModel?
    func fetchAll() throws -> [RunModel]
    func delete(id: RunModel.ID) throws
    func update(id: RunModel.ID, comfort: Int?, note: String?) throws
}
