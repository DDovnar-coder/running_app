import SwiftUI

enum Field {
    case weight, height, age
}

enum DataInputMode {
    case onboarding
    case edit
}

struct DataInputView: View {
    @AppStorage("user_age") var savedAge: String = ""
    @AppStorage("user_height") var savedHeight: String = ""
    @AppStorage("user_weight") var savedWeight: String = ""
    @AppStorage("user_gender") var savedGender: String = ""
    @AppStorage("has_completed_profile") private var hasCompletedProfile: Bool = false
    
    @State private var didAttemptSave: Bool = false
    
    @State private var age: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var gender: String = ""
    
    @FocusState private var focusedField: Field?
    
    @Environment(AppRouter.self) var router
    
     let mode: DataInputMode
    
    private var ageError: LocalizedStringKey? {
        if age.isEmpty {
            return LocalizedStringKey("datainput.age.error")
        }
        
        guard let age = Int(age), age > 0, age < 120 else {
            return LocalizedStringKey("datainput.age.error")
        }
        return nil
    }
    
    private var heightError: LocalizedStringKey? {
        if height.isEmpty {
            return LocalizedStringKey("datainput.height.error")
        }
        
        guard let heightInt = Int(height), heightInt > 0, heightInt < 300 else {
            return LocalizedStringKey("datainput.height.error")
        }
        return nil
    }
    
    private var weightError: LocalizedStringKey? {
        if weight.isEmpty {
            return LocalizedStringKey("datainput.weight.error")
        }
        
        guard let weightInt = Int(weight), weightInt > 0, weightInt < 300 else {
            return LocalizedStringKey("datainput.weight.error")
        }
        return nil
    }
    
    private var genderError: String? {
        guard gender == "male" || gender == "female" else {
            return NSLocalizedString("datainput.gender.error", comment: "")
        }
        return nil
    }
    
    private var isFormValid: Bool {
        return ageError == nil && !age.isEmpty
        && heightError == nil && !height.isEmpty
        && weightError == nil && !weight.isEmpty
        && genderError == nil
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("datainput.description")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        InputCard(title: "datainput.age.title", placeholder: "18", isFocused: $focusedField, field: .age, name: $age, errorMessage: didAttemptSave ? ageError : nil)
                        InputCard(title: "datainput.height.title", placeholder: "175", isFocused: $focusedField, field: .height, name: $height, errorMessage: didAttemptSave ? heightError : nil)
                        InputCard(title: "datainput.weight.title", placeholder: "65", isFocused: $focusedField, field: .weight, name: $weight, errorMessage: didAttemptSave ? weightError : nil)
                        GenderInputCard(gender: $gender)
                    }.padding(.top, 30)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }.navigationTitle("datainput.title")
            
            Button(action: {
                saveAndContinue()
            }){
                Text("datainput.continue.save")
                    .frame(maxWidth: .infinity)
            }
            .disabled(!isFormValid)
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .controlSize(.large)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            age = savedAge
            height = savedHeight
            weight = savedWeight
            gender = savedGender
            
            let firstEmptyField: Field? = {
                if age.isEmpty { return .age }
                if height.isEmpty { return .height }
                if weight.isEmpty { return .weight }
                return nil
            }()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                focusedField = firstEmptyField
            }
        }
    }
    
    private func saveAndContinue() {
        guard isFormValid else {
            didAttemptSave = true
            return
        }
        
        savedAge = age
        savedHeight = height
        savedWeight = weight
        savedGender = gender
        switch mode {
        case .onboarding:
            router.completeProfile()
        case .edit:
            router.pop()
        }
    }
}

