
import Foundation

protocol RunRepository {
    func save(_ run: RunModel) throws
    func fetchAll() throws -> [RunModel]
}
