import SwiftUI

func calculateCalories(duration: TimeInterval, weightKg: Double, met: Double = 9.8) -> Double {
    let hours = duration / 3600
    return hours * weightKg * met
}
