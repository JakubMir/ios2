//
//  MenuButton.swift
//  CookieCrusher
//
//  Created by Václav Vizváry on 28.12.2025.
//

import SwiftUI

struct MenuButton: View {
    let title: String
    let backgroundColor: Color
    let borderColor: Color
    var width: CGFloat = 250
    var cornerRadius: CGFloat = 15
    var borderWidth: CGFloat = 5
    var fontSize: CGFloat = 20
    
    var body: some View {
        Text(title)
            
            .foregroundColor(.black)
            .frame(maxWidth: width)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            )
            .font(.custom("Alkatra-Bold", size: 20))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
    }
}

