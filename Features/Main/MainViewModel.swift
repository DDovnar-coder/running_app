import SwiftUI

@Observable
final class MainViewModel {
    private(set) var runs: [RunModel] = []
    var runToDelete: RunModel?
    
    private let repository: RunRepository
        
    init(repository: RunRepository) {
        self.repository = repository
    }
    
    // MARK: - Состояние для отображения
    
    var isEmpty: Bool { runs.isEmpty }
    
    var totalDuration: TimeInterval {
        runs.reduce(0) { $0 + $1.duration }
    }
    
    func dateText(for run: RunModel) -> String {
        run.startDate.formatted(.dateTime.day().month().hour().minute())
    }
    
    func durationText(for run: RunModel) -> String {
        Duration.seconds(run.duration).formatted()
    }
    
    // MARK: - Действия
    
    var weeklyRunsCount: Int {
        weeklyRuns.count
    }
    
    var weeklyTotalDistanceString: String {
        let temporaryMockDistancePerRun = 5.0
        let totalKm = Double(weeklyRuns.count) * temporaryMockDistancePerRun
        
        // Когда появится GPS, эта логика заменится на реальную:
        // let totalKm = weeklyRuns.reduce(0.0) { $0 + ($1.distance ?? 0.0) }
        
        return String(format: "%.1f km", totalKm)
    }
    
    var chartData: [(id: Date, dayName: String, distance: Double)] {
        let calendar = Calendar.current
        var result: [(id: Date, dayName: String, distance: Double)] = []
        
        for offset in (-6)...0 {
            if let date = calendar.date(byAdding: .day, value: offset, to: Date()) {
                let currentDayLabel = date.formatted(.dateTime.weekday(.abbreviated))
                
                // Фильтруем пробежки текущей недели, совершенные в этот конкретный день
                let runsInThisDay = weeklyRuns.filter { calendar.isDate($0.startDate, inSameDayAs: date)  }
                
                var dayDistance = 0.0
                
                if !runsInThisDay.isEmpty {
                    // Пока нет GPS: даем по 4.5 км за каждую реальную тренировку в этот день календаря
                    dayDistance = Double(runsInThisDay.count) * 1.3
                    
                    // Когда появится GPS:
                    // dayDistance = runsInThisDay.reduce(0.0) { $0 + ($1.distance ?? 0.0) }
                }
                
                result.append((id: date, dayName: currentDayLabel, distance: dayDistance))
            }
        }
        
        return result
    }
    
    private var weeklyRuns: [RunModel] {
        let calendar = Calendar.current
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        return runs.filter { $0.startDate >= oneWeekAgo }
    }
    
    
    func loadRuns() {
        runs = (try? repository.fetchAll()) ?? []
    }
    
    func requestDelete(at offsets: IndexSet) {
        if let index = offsets.first {
            runToDelete = runs[index]
        }
    }
    
    func confirmDelete(_ run: RunModel) {
        do {
            try repository.delete(id: run.id)
            loadRuns()
        } catch {
            print(error)
        }
    }
}
