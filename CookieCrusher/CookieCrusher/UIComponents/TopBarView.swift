//
//  TopBarView.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import SwiftUI

struct TopBarView: View {
    var lives: Int = 5
    var currency: Int = 150
    
    var body: some View {
        HStack {
            // Životy
            HStack(spacing: 5) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.title2)
                Text("\(lives)")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
            
            Spacer()
            
            HStack(spacing: 5) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.title2)
                Text("\(currency)")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}
