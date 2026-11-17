import Foundation

final class WorkoutSessionStore {
    private let defaults: UserDefaults
    private let key = "active_workout_session"
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    func save(_ session: WorkoutSession) {
        guard let data = try? JSONEncoder().encode(session) else { return }
        defaults.set(data, forKey: key)
    }
    
    func load() -> WorkoutSession? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(WorkoutSession.self, from: data)
    }
    
    func clear() {
        defaults.removeObject(forKey: key)
    }
}
