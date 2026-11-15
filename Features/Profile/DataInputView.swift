import SwiftUI

enum Field {
    case weight, height, age
}

enum DataInputMode {
    case onboarding
    case edit
}

struct DataInputView: View {
    @State private var viewModel: DataInputViewModel
    @FocusState private var focusedField: Field?
    @Environment(AppRouter.self) var router

    init(viewModel: DataInputViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("datainput.description")
                        .font(.body)
                        .foregroundColor(.secondary)

                    VStack(alignment: .leading, spacing: 20) {
                        InputCard(title: "datainput.age.title", placeholder: "18", isFocused: $focusedField, field: .age, name: $viewModel.age, errorMessage: viewModel.didAttemptSave ? viewModel.ageError : nil)
                        InputCard(title: "datainput.height.title", placeholder: "175", isFocused: $focusedField, field: .height, name: $viewModel.height, errorMessage: viewModel.didAttemptSave ? viewModel.heightError : nil)
                        InputCard(title: "datainput.weight.title", placeholder: "65", isFocused: $focusedField, field: .weight, name: $viewModel.weight, errorMessage: viewModel.didAttemptSave ? viewModel.weightError : nil)
                        GenderInputCard(gender: $viewModel.gender)
                    }.padding(.top, 30)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .navigationTitle("datainput.title")

            Button {
                if viewModel.save() {
                    switch viewModel.mode {
                    case .onboarding: router.completeProfile()
                    case .edit: router.pop()
                    }
                }
            } label: {
                Text("datainput.continue.save").frame(maxWidth: .infinity)
            }
            .disabled(!viewModel.isFormValid)
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .controlSize(.large)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                focusedField = viewModel.firstEmptyField
            }
        }
    }
}
