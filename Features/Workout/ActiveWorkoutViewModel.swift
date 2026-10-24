import SwiftUI

@Observable
final class ActiveWorkoutViewModel {
    private(set) var isPaused = false

    private let workoutTimer = WorkoutTimer()
    private let repository: RunRepository
    private let defaults: UserDefaults

    init(repository: RunRepository, defaults: UserDefaults = .standard) {
        self.repository = repository
        self.defaults = defaults
    }

    // MARK: - Состояние для отображения

    var elapsedText: String {
        Duration.seconds(workoutTimer.elapsedTime).formatted()
    }

    // MARK: - Действия

    func start() {
        workoutTimer.start()
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
        return id
    }

    // MARK: - Приватное

    private func saveRun() -> UUID? {
        let weightString = defaults.string(forKey: "user_weight") ?? ""
        let weightKg = Double(weightString) ?? 0
        let calories = calculateCalories(duration: workoutTimer.elapsedTime, weightKg: weightKg)

        guard let start = workoutTimer.workoutStartTimer else { return nil }
        let run = RunModel(
            startDate: start,
            duration: workoutTimer.elapsedTime,
            calories: Int(calories.rounded())
        )
        try? repository.save(run)
        return run.id
    }
}
