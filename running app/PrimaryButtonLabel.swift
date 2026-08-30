//
//  PrimaryButtonLabel.swift
//  running app
//
//  Created by DDovnar on 07.08.2026.
//

import SwiftUI

struct PrimaryButtonLabel: View {
    var title: LocalizedStringKey
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(Color(hex: "0A84FF"))
            .cornerRadius(10)
    }
}
