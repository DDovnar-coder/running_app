import SwiftUI

protocol HealthService {
    func requestAccess() async throws
    func fetchProfile() async throws -> HealthProfile
}
