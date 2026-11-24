struct HealthProfile {
    let age: Int?
    let height: Double?
    let weight: Double?
    let biologicalSex: BiologicalSex?
}

enum BiologicalSex {
    case male
    case female
    case other
}
