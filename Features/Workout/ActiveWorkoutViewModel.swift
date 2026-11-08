import SwiftUI

@Observable
final class ActiveWorkoutViewModel {
    private(set) var isPaused = false
    
    private let workoutTimer = WorkoutTimer()
    private let repository: RunRepository
    private let defaults: UserDefaults
    
    private let liveActivityManager: LiveActivityManager
    private var lastLiveActivityUpdate: Date?
    
    init(repository: RunRepository, defaults: UserDefaults = .standard, liveActivityManager: LiveActivityManager) {
        self.repository = repository
        self.defaults = defaults
        self.liveActivityManager = liveActivityManager
        
        workoutTimer.onTick = { [weak self] in
            self?.updateLiveActivityIfNeeded()
        }
    }
    
    // MARK: - Состояние для отображения
    
    var elapsedText: String {
        Duration.seconds(workoutTimer.elapsedTime).formatted()
    }
    
    // MARK: - Действия
    
    func start() {
        lastLiveActivityUpdate = nil
        workoutTimer.start()
        liveActivityManager.startWorkout()
    }
    
    func togglePause() {
        if isPaused {
            workoutTimer.resume()
        } else {
            workoutTimer.pause()
        }
        isPaused.toggle()
    }
    
    // Сохраняет забег и останавливает таймер.
    // Возвращает id сохранённого забега, чтобы View могла открыть итоги.
    func finish() -> UUID? {
        let id = saveRun()
        workoutTimer.stop()
        
        liveActivityManager.stopWorkout()
        return id
    }
    
    // MARK: - Приватное
    
    private func countCalories() -> Double {
        let weightString = defaults.string(forKey: "user_weight") ?? ""
        let weightKg = Double(weightString) ?? 0
        
        let calories = calculateCalories(duration: workoutTimer.elapsedTime, weightKg: weightKg)
        
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
        liveActivityManager.updateWorkout(
            distance: 0.0,
            pace: "--:--",
            kcal: Int(countCalories().rounded())
        )
    }
    
    private func saveRun() -> UUID? {
        guard let start = workoutTimer.workoutStartTimer else { return nil }
        let run = RunModel(
            startDate: start,
            duration: workoutTimer.elapsedTime,
            calories: Int(countCalories().rounded())
        )
        try? repository.save(run)
        return run.id
    }
}
