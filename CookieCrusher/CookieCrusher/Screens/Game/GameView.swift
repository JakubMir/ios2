//
//  GameView.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 28.12.2025.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: GameViewModel
    
    init(level: LevelData) {
        _viewModel = StateObject(wrappedValue: GameViewModel(levelData: level))
    }
    
    var body: some View {
        ZStack {
            // BG
            Image(viewModel.currentLevel.backgroundName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                // TOP BAR
                HStack {
                    VStack(spacing: 0) {
                        Text("SCORE").font(.custom("Alkatra-Bold", size: 20)).foregroundColor(.purple)
                        Text("\(viewModel.score)").font(.custom("Alkatra-Bold", size: 24)).foregroundColor(.white)
                    }
                    Spacer()
                    VStack(spacing: 0) {
                        Text("MOVES").font(.custom("Alkatra-Bold", size: 20)).foregroundColor(.purple)
                        Text("\(viewModel.moves)").font(.custom("Alkatra-Bold", size: 24)).foregroundColor(.white)
                    }
                    Spacer()
                    Button(action: { viewModel.isPaused = true }) {
                        Image("Buttons-pause").resizable().frame(width: 50, height: 50)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
                
                // GAME
                ZStack {
                    // ODSTRANĚNO: RoundedRectangle(cornerRadius: 20)... (řeší to GameScene)
                    // Ponecháme jen container pro SpriteView
                    
                    SpriteView(scene: viewModel.scene, options: [.allowsTransparency])
                        .frame(width: 350, height: 550)
                        // .cornerRadius(15) // Volitelné, pokud chceš oříznout rohy
                }
                .frame(width: 350, height: 550)
                
                Spacer()
            }
            .blur(radius: viewModel.isPaused ? 5 : 0)
            
            // PAUSE MENU
            if viewModel.isPaused {
                Color.black.opacity(0.6).ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("PAUSED").font(.custom("Alkatra-Bold", size: 40)).foregroundColor(.white)
                    HStack(spacing: 30) {
                        Button(action: { viewModel.isPaused = false }) {
                            Image("Buttons-arrow").resizable().frame(width: 80, height: 80)
                        }
                        Button(action: { dismiss() }) {
                            Image("Buttons-house").resizable().frame(width: 80, height: 80)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.handleGameStart()
        }
    }
}
