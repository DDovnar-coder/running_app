//
//  GenderInputCard.swift
//  running app
//
//  Created by DDovnar on 07.08.2026.
//

import SwiftUI

struct GenderInputCard: View {
    @Binding var gender: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("datainput.gender.title")
            Picker("", selection: $gender) {
                Text("datainput.gender.male").tag("male")
                Text("datainput.gender.female").tag("female")
            }
            .pickerStyle(.segmented)
        }
        .padding(15)
        .background(Color(white: 0.95))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 2)
    }
}
