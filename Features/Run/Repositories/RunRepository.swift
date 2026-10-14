
import Foundation

protocol RunRepository {
    func save(_ run: RunModel) throws
    func fetchAll() throws -> [RunModel]
    func fetch(id: RunModel.ID) throws -> RunModel?
    func delete(id: RunModel.ID) throws
    func update(id: RunModel.ID, comfort: Int?, note: String?, chips: [String]) throws
}
