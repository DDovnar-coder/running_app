import SwiftUI

@Observable
final class ActiveWorkoutViewModel {
    private let workoutTimer = WorkoutTimer()
    private let repository: RunRepository
    private let defaults: UserDefaults
    
    private let liveActivityManager: LiveActivityManager
    private var lastLiveActivityUpdate: Date?
    
    private(set) var session: WorkoutSession?
    private let store: WorkoutSessionStore
    
    var isPaused: Bool {
         session?.pausedAt != nil
    }
    
    init(repository: RunRepository, defaults: UserDefaults, liveActivityManager: LiveActivityManager, store: WorkoutSessionStore) {
        self.repository = repository
        self.defaults = defaults
        self.liveActivityManager = liveActivityManager
        self.store = store
        
        workoutTimer.onTick = { [weak self] in
            self?.updateLiveActivityIfNeeded()
        }
    }
    
    // MARK: - Состояние для отображения
    var elapsedText: String {
        _ = workoutTimer.tickCount
        return Duration.seconds(session?.elapsed() ?? 0).formatted()
    }
    // MARK: - Действия
    
    func start() {
        lastLiveActivityUpdate = nil
        let newSession = WorkoutSession(startTime: .now)
        session = newSession
        store.save(newSession)
        workoutTimer.start()
        liveActivityManager.startWorkout(session: newSession)
    }
    
    func togglePause() {
        if isPaused {
            session?.resume()
            workoutTimer.start()
        } else {
            session?.pause()
            workoutTimer.stop()
        }
        
        if let session { store.save(session) }
    }
    
    // Сохраняет забег и останавливает таймер.
    // Возвращает id сохранённого забега, чтобы View могла открыть итоги.
    func finish() -> UUID? {
        let id = saveRun()
        workoutTimer.stop()
        session = nil
        store.clear()
        liveActivityManager.stopWorkout()
        return id
    }
    
    func startOrRestore() {
        guard session == nil else { return }
        if let saved = store.load() {
            restore(saved)
        } else {
            start()
        }
    }

    private func restore(_ saved: WorkoutSession) {
        session = saved
        if !isPaused { workoutTimer.start() }
        liveActivityManager.restoreOrStart(session: saved)
    }
    
    // MARK: - Приватное
    
    private func countCalories() -> Double {
        let weightString = defaults.string(forKey: "user_weight") ?? ""
        let weightKg = Double(weightString) ?? 0
        
        let calories = calculateCalories(duration: session?.elapsed() ?? 0, weightKg: weightKg)
        
        return calories
    }
    
    private func updateLiveActivityIfNeeded() {
        let now = Date()
        
        if let lastUpdate = lastLiveActivityUpdate,
           now.timeIntervalSince(lastUpdate) < 15 {
            return
        }
        
        lastLiveActivityUpdate = now
        updateLiveActivity()
    }
    
    private func updateLiveActivity() {
        guard let session else { return }
        liveActivityManager.updateWorkout(
            session: session,
            distance: 0.0,
            pace: "--:--",
            kcal: Int(countCalories().rounded())
        )
    }
  
    func restoreIfNeeded() {
        guard session == nil, let saved = store.load() else { return }
        session = saved
        if !isPaused { workoutTimer.start() }
        liveActivityManager.restoreOrStart(session: saved)
    }
    
    private func saveRun() -> UUID? {
        guard let session else { return nil }
        let run = RunModel(
            startDate: session.startTime,
            duration: session.elapsed(),
            calories: Int(countCalories().rounded())
        )
        try? repository.save(run)
        return run.id
    }
}
