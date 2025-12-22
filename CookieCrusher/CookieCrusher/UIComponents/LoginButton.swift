//
//  LoginButton.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import SwiftUI

struct LoginButton: View {
    var title: String
    var isPrimary: Bool = true
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title.uppercased())
                .font(.headline)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(isPrimary ? Color("Primary") : Color("Secondary"))
                .cornerRadius(25)
        }
    }
}
