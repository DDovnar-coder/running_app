import SwiftUI

@Observable
final class DataInputViewModel {
    var age = ""
    var height = ""
    var weight = ""
    var gender = ""
    var didAttemptSave = false
    
    let mode: DataInputMode
    
    var isLoadingHealthData = false
    var healthDataError: LocalizedStringKey?
    
    private let defaults: UserDefaults
    private let healthService: HealthService
    private var didLoadHealthData = false
    
    
    init(mode: DataInputMode, defaults: UserDefaults, healthService: HealthService) {
        self.mode = mode
        self.defaults = defaults
        self.healthService = healthService
        
        age = defaults.string(forKey: "user_age") ?? ""
        height = defaults.string(forKey: "user_height") ?? ""
        weight = defaults.string(forKey: "user_weight") ?? ""
        gender = defaults.string(forKey: "user_gender") ?? ""
    }
    
    private func numberError(_ text: String, max: Int, key: String) -> LocalizedStringKey? {
        guard let value = Int(text), value > 0, value < max else {
            return LocalizedStringKey(key)
        }
        return nil
    }
    
    var ageError: LocalizedStringKey? { numberError(age, max: 120, key: "datainput.age.error") }
    var heightError: LocalizedStringKey? { numberError(height, max: 300, key: "datainput.height.error") }
    var weightError: LocalizedStringKey? { numberError(weight, max: 300, key: "datainput.weight.error") }
    
    var genderError: String? {
        guard gender == "male" || gender == "female" else {
            return NSLocalizedString("datainput.gender.error", comment: "")
        }
        return nil
    }
    
    var isFormValid: Bool {
        ageError == nil && heightError == nil && weightError == nil && genderError == nil
    }
    
    var firstEmptyField: Field? {
        if age.isEmpty { return .age }
        if height.isEmpty { return .height }
        if weight.isEmpty { return .weight }
        return nil
    }
    
    /// Возвращает true, если сохранение прошло и можно уходить с экрана
    func save() -> Bool {
        guard isFormValid else {
            didAttemptSave = true
            return false
        }
        defaults.set(age, forKey: "user_age")
        defaults.set(height, forKey: "user_height")
        defaults.set(weight, forKey: "user_weight")
        defaults.set(gender, forKey: "user_gender")
        return true
    }
    
    func loadHealthData() async {
        guard mode == .onboarding,
              !didLoadHealthData,
              !isLoadingHealthData else {
            return
        }
        
        isLoadingHealthData = true
        healthDataError = nil
        
        defer {
            isLoadingHealthData = false
        }
        
        do {
            try await healthService.requestAccess()
            
            let profile = try await healthService.fetchProfile()
            
            if age.isEmpty, let value = profile.age {
                age = String(value)
            }
            
            if height.isEmpty, let value = profile.height {
                height = String(Int(value))
            }
            
            if weight.isEmpty, let value = profile.weight {
                weight = String(Int(value))
            }
            
            if gender.isEmpty, let value = profile.biologicalSex {
                switch value {
                case .male:
                    gender = "male"
                case .female:
                    gender = "female"
                case .other:
                    break
                }
            }
            
            didLoadHealthData = true
        } catch {
            healthDataError = "datainput.health.error"
        }
    }
}
