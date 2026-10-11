//
//  ActiveWorkoutView.swift
//  running app
//
//  Created by DDovnar on 17.08.2026.
//

import SwiftUI
import SwiftData

struct ActiveWorkoutView: View {
    @State private var isPaused: Bool = false
    @State private var showEndConfirmation: Bool = false
    @State private var workoutTimer: WorkoutTimer = WorkoutTimer()
    @Environment(AppRouter.self) private var router
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let runRepository: RunRepository
    
    var body: some View {
        VStack {
            Spacer()
            VStack() {
                Text(Duration.seconds(workoutTimer.elapsedTime).formatted())
                    .font(.system(size: 80, weight: .bold, design: .monospaced))
                Text("activeWorkout.elapsedTime")
                    .font(.callout)
                    .foregroundStyle(.gray)
            }
            
            HStack(spacing: 0) {
                MetricStat(value: "2.14", unit: "km", label: "activeWorkout.distance")
                Divider().frame(height: 34)
                MetricStat(value: "6:47", unit: "/km", label: "activeWorkout.pace")
            }
            .padding(.top, 40)
            
            Spacer()
            
            HStack(spacing: 24) {
                Button(action: {
                    if isPaused {
                        workoutTimer.resume()
                    } else {
                        workoutTimer.pause()
                    }
                    isPaused.toggle()
                }) {
                    Image(systemName: isPaused ? "play.fill" : "pause.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 64, height: 64)
                        .background(Circle().fill(.orange))
                }
                HoldToStopButton(onComplete: {
                    let id = saveRun()
                    workoutTimer.stop()
                    router.pop()
                    if let id { router.push(.summary(id: id)) }
                })
                    
            }
            
            Spacer()
        }
        .toolbar(.hidden, for: .navigationBar)
        .padding(25)
        .onAppear {
            workoutTimer.start()
        }
    }
    
    private func saveRun() -> UUID? {
        let weightString = UserDefaults.standard.string(forKey: "user_weight") ?? ""
        let weightKg = Double(weightString) ?? 0
        let calories = calculateCalories(duration: workoutTimer.elapsedTime, weightKg: weightKg)
        
        guard let start = workoutTimer.workoutStartTimer else { return nil }
        let run = RunModel(startDate: start, duration: workoutTimer.elapsedTime, calories: Int(calories.rounded()))
        try? runRepository.save(run)
        return run.id
    }
}

