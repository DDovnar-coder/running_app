import HealthKit

enum HealthKitServiceError: Error {
    case healthKitUnavailable
    case authorizationFailed
}

final class HealthKitService: HealthService {
    private let healthStore: HKHealthStore?
    
    private var isHealthKitAvailable: Bool {
        healthStore != nil
    }
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            self.healthStore = HKHealthStore()
        } else {
            self.healthStore = nil
        }
    }
    
    func requestAccess() async throws {
        guard let healthStore else {
            throw HealthKitServiceError.healthKitUnavailable
        }
        
        let readTypes: Set<HKObjectType> = [
            HKCharacteristicType(.dateOfBirth),
            HKCharacteristicType(.biologicalSex),
            HKQuantityType(.height),
            HKQuantityType(.bodyMass)
        ]
        
        try await healthStore.requestAuthorization(
            toShare: [],
            read: readTypes
        )
    }
    
    func fetchProfile() async throws -> HealthProfile {
        guard let healthStore else { throw HealthKitServiceError.healthKitUnavailable }
        
        let dateOfBirth = try healthStore.dateOfBirthComponents()
        
        let age = fetchAge(from: dateOfBirth)
        let biologicalSex = try fetchBiologicalSex()
        let height = try await fetchHeight()
        let weight = try await fetchWeight()
        
        
        return HealthProfile(
            age: age,
            height: height,
            weight: weight,
            biologicalSex: biologicalSex
        )
    }
    
    private func fetchAge(from dateOfBirth: DateComponents) -> Int? {
        guard let birthDate = Calendar.current.date(from: dateOfBirth) else {
            return nil
        }
        
        let ageComponents = Calendar.current.dateComponents(
            [.year],
            from: birthDate,
            to: Date()
        )
        
        return ageComponents.year
    }
    
    private func fetchBiologicalSex() throws -> BiologicalSex? {
        guard let healthStore else {
            throw HealthKitServiceError.healthKitUnavailable
        }
        
        let biologicalSex = try healthStore.biologicalSex()
        
        switch biologicalSex.biologicalSex {
        case .male:
            return .male
            
        case .female:
            return .female
            
        case .other:
            return .other
            
        case .notSet:
            return nil
            
        @unknown default:
            return nil
        }
    }
    
    private func fetchHeight() async throws -> Double? {
        guard let healthStore else {
            throw HealthKitServiceError.healthKitUnavailable
        }
        
        let heightType = HKQuantityType(.height)
        
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.quantitySample(type: heightType)],
            sortDescriptors: [
                SortDescriptor(\.endDate, order: .reverse)
            ],
            limit: 1
        )
        
        let samples = try await descriptor.result(for: healthStore)
        
        guard let sample = samples.first else {
            return nil
        }
        
        let heightInCentimeters = sample.quantity.doubleValue(
            for: .meterUnit(with: .centi)
        )
        
        return heightInCentimeters
    }
    
    private func fetchWeight() async throws -> Double? {
        guard let healthStore else {
            throw HealthKitServiceError.healthKitUnavailable
        }
        
        let weightType = HKQuantityType(.bodyMass)
        
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.quantitySample(type: weightType)],
            sortDescriptors: [
                SortDescriptor(\.endDate, order: .reverse)
            ],
            limit: 1
        )
        
        let samples = try await descriptor.result(for: healthStore)
        
        guard let sample = samples.first else {
            return nil
        }
        
        let weightInKilograms = sample.quantity.doubleValue(
            for: .gramUnit(with: .kilo)
        )
        
        return weightInKilograms
    }
}

