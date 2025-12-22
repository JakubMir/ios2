//
//  LoginButton.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import SwiftUI

struct LoginButton: View {
    var title: String
    var action: () -> Void
    var isPrimary: Bool = true
    
    var body: some View {
        Button(action: action) {
            Text(title.uppercased())
                .font(.headline)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color(red: 0.1, green: 0.75, blue: 0.75))
                .cornerRadius(25)
        }
    }
}
