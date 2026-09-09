//
//  InputCard.swift
//  running app
//
//  Created by DDovnar on 07.08.2026.
//

import SwiftUI

struct InputCard: View {
    var title: LocalizedStringKey
    var placeholder: LocalizedStringKey
    var isFocused: FocusState<Field?>.Binding
    var field: Field
    @Binding var name: String
    var errorMessage: LocalizedStringKey? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            TextField(placeholder, text: $name)
                .keyboardType(.numberPad)
                .padding(5)
                .focused(isFocused, equals: field)
                .overlay(
                    Rectangle()
                        .frame(height: 1.5)
                        .foregroundStyle(
                            errorMessage != nil
                            ? .red
                            : (isFocused.wrappedValue == field ? Color(hex: "0A84FF") : Color.gray)
                        ),
                    alignment: .bottom
                )
            
            if let errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
            
        }
        .padding(15)
        .background(Color(white: 0.95))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 2)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


