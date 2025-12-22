//
//  LoginTextField.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import SwiftUI

struct LoginTextField: View {
    var title: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .bold()
                .foregroundColor(.black.opacity(0.7))
                .padding(.leading, 10)
            
            if isSecure {
                SecureField(title, text: $text)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .foregroundColor(.black)
            } else {
                TextField(title, text: $text)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .foregroundColor(.black)
            }
        }
    }
}
