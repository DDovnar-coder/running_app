import SwiftUI

struct ComfortSlider: View {
    @Binding var currentStep: Int
    @Binding var hasRated: Bool
    private let totalSteps: Int = 4
    private let stepLabels = ["x1", "x2", "x3", "x4"]
    var isInteractive: Bool = true

    var body: some View {
       GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(hex: "E9F0EB"))
                    .frame(height: 44)
                    .overlay(
                        Capsule()
                              .stroke(Color(hex: "C4C8C5"), lineWidth: 2)
                    )
                
                HStack(spacing: 0) {
                    ForEach(0..<totalSteps, id: \.self) { index in
                        Text(stepLabels[index])
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(currentStep == index ? .clear : Color(hex: "78847C"))
                            .frame(width: geometry.size.width / CGFloat(totalSteps), height: 44)
                    }
                }
                
                let stepWidth = geometry.size.width / CGFloat(totalSteps)
                
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                    Text(stepLabels[currentStep])
                }
                .font(.system(.callout, design: .rounded))
                .fontWeight(.bold)
                .foregroundStyle(.black)
                .frame(width: stepWidth - 4, height: 40)
                .background(
                    Capsule()
                        .fill(Color(hex: "35C866"))
                )
                .padding(.leading, 2)
                .offset(x: CGFloat(currentStep) * stepWidth)
                .animation(.spring(response: 0.25, dampingFraction: 0.75), value: currentStep)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        hasRated = true
                        let locationX = value.location.x
                        let progress = locationX / geometry.size.width
                        let calculatedStep = Int((progress * CGFloat(totalSteps)).clamped(to: 0...CGFloat(totalSteps - 1)))
                        if currentStep != calculatedStep {
                            currentStep = calculatedStep
                            triggerHapticFeedback()
                        }
                    }
            )
        }
        .frame(height: 44)
        .allowsHitTesting(isInteractive)
    }
    
    private func triggerHapticFeedback() {
        let impactMed = UIImpactFeedbackGenerator(style: .light)
        impactMed.impactOccurred()
    }

}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
