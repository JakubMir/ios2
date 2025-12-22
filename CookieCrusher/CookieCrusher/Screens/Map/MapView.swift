//
//  MapView.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import SwiftUI

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 0) {
                            
                            ForEach(viewModel.worlds) { world in
                                WorldView(world: world, viewModel: viewModel)
                            }
                        }
                        .padding(.bottom, 0)
                    }
                    .ignoresSafeArea()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                proxy.scrollTo(viewModel.userMaxLevel, anchor: .center)
                            }
                        }
                    }
                }
                
                TopBarView(lives: 5, currency: 250)
            }
        }
    }
}

struct WorldView: View {
    let world: World
    @ObservedObject var viewModel: MapViewModel
    
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
                        stars: levelNumber < viewModel.userMaxLevel ? Int.random(in: 1...3) : 0, // Mock hvězdy
                        action: {
                            print("Kliknuto na level \(levelNumber)")
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
