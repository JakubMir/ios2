//
//  LoginBackground.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import SwiftUI

struct LoginBackground: View {
    var body: some View {
            ZStack {
                Image("menu_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
        }
}

#Preview {
    LoginBackground()
}
