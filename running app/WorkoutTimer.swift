//
//  WorkoutTimer.swift
//  running app
//
//  Created by DDovnar on 22.08.2026.
//

import Foundation
import Observation

@Observable
class WorkoutTimer {
    private var startTime: Date?
    private var pausedAt: Date?
    private var pausedDuration: TimeInterval = 0
    private var timer: Timer?
    
    private(set) var elapsedTime: TimeInterval = 0
        
    func start() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    private func tick() {
        guard let startTime else { return }
        
        elapsedTime = Date().timeIntervalSince(startTime) - pausedDuration
    }
    
    func pause() {
        pausedAt = Date()
        timer?.invalidate()
    }
    
    func resume() {
        guard let pausedAt else { return }
        pausedDuration += Date().timeIntervalSince(pausedAt)
        self.pausedAt = nil
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
               self?.tick()
        }
    }
    
    func stop() {
        elapsedTime = 0
        timer?.invalidate()
        pausedDuration = 0
        pausedAt = nil
        startTime = nil
    }
}
