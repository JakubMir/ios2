//
//  LevelNodeView.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import SwiftUI

struct LevelNodeView: View {
    let levelNumber: Int
    let isLocked: Bool
    let stars: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.2))
                    .frame(width: 70, height: 70)
                    .offset(y: 4)
                
                Circle()
                    .fill(isLocked ? Color.gray : Color.pink)
                    .frame(width: 65, height: 65)
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 3)
                    )
                
                if isLocked {
                    Image(systemName: "lock.fill")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.6))
                } else {
                    VStack(spacing: 0) {
                        Text("\(levelNumber)")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                        
                        if stars > 0 {
                            HStack(spacing: 2) {
                                ForEach(0..<3) { i in
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 10))
                                        .foregroundColor(i < stars ? .yellow : .black.opacity(0.3))
                                }
                            }
                        }
                    }
                }
            }
        }
        .disabled(isLocked)
        .shadow(radius: 5)
    }
}
