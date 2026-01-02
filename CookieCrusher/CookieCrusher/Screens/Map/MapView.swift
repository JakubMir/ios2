//
//  MapView.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 28.12.2025.
//

import SwiftUI

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    
    @State private var selectedLevelToPlay: LevelData?
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 0) {
                            
                            ForEach(viewModel.worlds) { world in
                                WorldView(
                                    world: world,
                                    viewModel: viewModel,
                                    onLevelSelect: { levelId in
                                        startGame(id: levelId)
                                    }
                                )
                            }
                        }
                        .padding(.bottom, 0)
                    }
                    .ignoresSafeArea()
                    .onAppear {
                        viewModel.fetchData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                proxy.scrollTo(viewModel.userMaxLevel, anchor: .center)
                            }
                        }
                    }
                }
                
                TopBarView(lives: viewModel.userLives, currency: 250)
            }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(item: $selectedLevelToPlay) { levelData in
            GameView(level: levelData)
        }
    }
    
    private func startGame(id: Int) {
        let levelData = LevelsService.shared.getLevel(id: id)
        
        print("Spouštím Level \(id): Layout \(levelData.layout != nil ? "Ano" : "Ne"), BG: \(levelData.backgroundName)")
        
        selectedLevelToPlay = levelData
    }
}

struct WorldView: View {
    let world: World
    @ObservedObject var viewModel: MapViewModel
    
    var onLevelSelect: (Int) -> Void
    
    var body: some View {
        ZStack {
            Image(world.backgroundName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                
                ForEach(world.levelRange.reversed(), id: \.self) { levelNumber in
                    
                    LevelNodeView(
                        levelNumber: levelNumber,
                        isLocked: levelNumber > viewModel.userMaxLevel,
                        stars: levelNumber < viewModel.userMaxLevel ? Int.random(in: 1...3) : 0,
                        action: {
                            onLevelSelect(levelNumber)
                        }
                    )
                    .offset(x: viewModel.getXOffset(for: levelNumber))
                    .id(levelNumber)
                }
            }
            .padding(.vertical, 50)
        }
    }
}

#Preview {
    MapView()
}
