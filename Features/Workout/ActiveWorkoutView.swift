import SwiftUI

struct ActiveWorkoutView: View {
    @State private var viewModel: ActiveWorkoutViewModel
    @Environment(AppRouter.self) private var router

    init(viewModel: ActiveWorkoutViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text(viewModel.elapsedText)
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
                Button(action: { viewModel.togglePause() }) {
                    Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 64, height: 64)
                        .background(Circle().fill(.orange))
                }
                HoldToStopButton(onComplete: {
                    let id = viewModel.finish()
                    router.pop()
                    if let id { router.push(.summary(id: id)) }
                })
            }

            Spacer()
        }
        .toolbar(.hidden, for: .navigationBar)
        .padding(25)
        .onAppear { viewModel.start() }
    }
}
