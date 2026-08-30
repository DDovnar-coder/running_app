//
//  ActiveWorkoutView.swift
//  running app
//
//  Created by DDovnar on 17.08.2026.
//

import SwiftUI

struct ActiveWorkoutView: View {
    var time: String = "13:00"
    @State private var isPaused: Bool = false
    @State private var showEndConfirmation: Bool = false
    @State private var workoutTimer: WorkoutTimer = WorkoutTimer()
    @Environment(\.dismiss) private var dismiss
    
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
            
//            Button(action: {workoutTimer.start()}) {
//                Text("Start")
//            }
            
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
                    workoutTimer.stop()
                    dismiss()
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
}

#Preview {
    ActiveWorkoutView()
}
