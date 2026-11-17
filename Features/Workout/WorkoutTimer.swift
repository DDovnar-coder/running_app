import Foundation
import Observation

@Observable
class WorkoutTimer {
    @ObservationIgnored var onTick: (() -> Void)?
    @ObservationIgnored private var timer: Timer?
    
    private(set) var tickCount = 0
        
    func start() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    private func tick() {
        tickCount += 1
        onTick?()
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
