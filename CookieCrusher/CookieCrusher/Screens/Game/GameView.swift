//
//  GameView.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 28.12.2025.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    @Environment(\.dismiss) var dismiss
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 5), count: 6)
    
    var body: some View {
        ZStack {
            Image("level_1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    // Score
                    VStack(spacing: 0) {
                        Text("SCORE")
                            .font(.custom("Alkatra-Bold", size: 20))
                            .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.3))
                        Text("\(viewModel.score)")
                            .font(.custom("Alkatra-Bold", size: 24))
                            .foregroundColor(.white)
                            .shadow(radius: 1)
                    }
                    
                    Spacer()
                    
                    // Moves
                    VStack(spacing: 0) {
                        Text("MOVES")
                            .font(.custom("Alkatra-Bold", size: 20))
                            .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.3))
                        Text("\(viewModel.moves)")
                            .font(.custom("Alkatra-Bold", size: 24))
                            .foregroundColor(.white)
                            .shadow(radius: 1)
                    }
                    
                    Spacer()
                    
                    // Pause Button
                    Button(action: {
                        withAnimation { viewModel.isPaused = true }
                    }) {
                        Image("Buttons-pause")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.4))
                        .padding(-10)
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(Array(viewModel.cookies.enumerated()), id: \.element.id) { index, cookie in
                            
                            Image("\(cookie.type)")
                                .resizable()
                                .scaledToFit()
                                .shadow(radius: 3)
                                .gesture(
                                    DragGesture()
                                        .onEnded { value in
                                            handleSwipe(value: value, index: index)
                                        }
                                )
                        }
                    }
                }
                .padding(20)
                .frame(maxWidth: 400)
                
                Spacer()
                
            }
            .blur(radius: viewModel.isPaused ? 5 : 0)
            
            if viewModel.isPaused {
                Color.black.opacity(0.6).ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("PAUSED")
                        .font(.custom("Alkatra-Bold", size: 40))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 30) {
                        Button(action: {
                            withAnimation { viewModel.isPaused = false }
                        }) {
                            Image("Buttons-arrow")
                                .resizable()
                                .frame(width: 80, height: 80)
                        }
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Image("Buttons-house")
                                .resizable()
                                .frame(width: 80, height: 80)
                        }
                    }
                }
                .transition(.scale)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // Logika gesta (zjistit směr a prohodit)
    private func handleSwipe(value: DragGesture.Value, index: Int) {
        let horizontal = value.translation.width
        let vertical = value.translation.height
        
        // Musí to být dostatečně dlouhý tah
        if abs(horizontal) < 20 && abs(vertical) < 20 { return }
        
        var targetIndex: Int?
        
        if abs(horizontal) > abs(vertical) {
            // Vodorovně
            if horizontal > 0 { // Doprava
                if (index + 1) % 6 != 0 { targetIndex = index + 1 }
            } else { // Doleva
                if index % 6 != 0 { targetIndex = index - 1 }
            }
        } else {
            // Svisle
            if vertical > 0 { // Dolů
                if index + 6 < viewModel.cookies.count { targetIndex = index + 6 }
            } else { // Nahoru
                if index - 6 >= 0 { targetIndex = index - 6 }
            }
        }
        
        if let target = targetIndex {
            withAnimation(.spring()) {
                viewModel.swapCookies(sourceIndex: index, targetIndex: target)
            }
        }
    }
}

#Preview {
    GameView()
}
