//
//  HoldToStopButton.swift
//  running app
//
//  Created by DDovnar on 19.08.2026.
//

import SwiftUI

struct HoldToStopButton: View {
    @State private var isPressing: Bool = false
    @State private var progress: CGFloat = 0.0
    
    private let duration: TimeInterval = 1.5
    
    var onComplete: () -> Void
    
    var body: some View {
        Button(action: {}) {
            ZStack {
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(
                        .red,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 76, height: 76)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: duration), value: progress)
                
                ZStack {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 64, height: 64)
                        .background(Circle().fill(.red))
                }
                .frame(width: 64, height: 64)
            }
        }
        .buttonStyle(StaticButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressing {
                        isPressing = true
                        progress = 1.0
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            if isPressing {
                                handleSuccess()
                            }
                        }
                    }
                }.onEnded{ _ in
                    resetPressing()
                }
        )
    }
    
    private func handleSuccess() {
          resetPressing()
          
          // Тактильный отклик (вибрация) при успешном завершении
          let generator = UINotificationFeedbackGenerator()
          generator.notificationOccurred(.success)
          
          onComplete()
      }
    
    private func resetPressing() {
            isPressing = false
            progress = 0.0
        }

    struct StaticButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
        }
    }
}
