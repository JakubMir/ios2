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
    
    init() {
          UIScrollView.appearance().bounces = false
       }

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
            .padding(.top, 100)
          }
          .ignoresSafeArea()

          .onAppear {
            viewModel.fetchData()
            proxy.scrollTo(viewModel.getArea(), anchor: .bottom)

            if viewModel.userMaxLevel > 0 {
              scrollToLevel(viewModel.getArea(), proxy: proxy)
            }
          }

          .onChange(of: viewModel.userMaxLevel) {
            scrollToLevel(viewModel.getArea(), proxy: proxy)
          }
        }

          TopBarView(lives: viewModel.userLives, currency: viewModel.getAllStars(), lastLifeLost: viewModel.userLastLifeLost, onTimerExpired: {
            print("Časovač na nule -> Obnovuji data...")
            viewModel.fetchData()
        }) // TODO: vm stars
      }
    }
    .navigationBarBackButtonHidden(true)
    .fullScreenCover(
      item: $selectedLevelToPlay,
      onDismiss: {
        viewModel.fetchData()
      }
    ) { levelData in
      GameView(level: levelData)
    }
  }

  private func startGame(id: Int) {
    let levelData = LevelsService.shared.getLevel(id: id)

    print(
      "Spouštím Level \(id): Layout \(levelData.layout != nil ? "Ano" : "Ne"), BG: \(levelData.backgroundName)"
    )

    selectedLevelToPlay = levelData
  }

  private func scrollToLevel(_ level: Int, proxy: ScrollViewProxy) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      withAnimation(.easeInOut(duration: 1.0)) {
        proxy.scrollTo(level, anchor: .bottom)
      }
    }
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
            stars: viewModel.getStars(for: levelNumber),
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
