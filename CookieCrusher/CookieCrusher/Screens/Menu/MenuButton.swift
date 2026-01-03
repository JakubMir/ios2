//
//  MenuButton.swift
//  CookieCrusher
//
//  Created by Václav Vizváry on 28.12.2025.
//

import SwiftUI

struct MenuButton: View {
    let title: String
    var action: () -> Void = {}
    let backgroundColor: Color
    let borderColor: Color
    var width: CGFloat = 250
    var cornerRadius: CGFloat = 15
    var borderWidth: CGFloat = 5
    var fontSize: CGFloat = 20
    
    var body: some View {
        Button(action: {}) {
            Text(title)
                .font(.system(size: fontSize, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: width)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(backgroundColor)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
        }
    }
}
