//
//  GameView.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 28.12.2025.
//

internal import GameplayKit
import SpriteKit
import SwiftUI

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
            Text("SCORE").font(.custom("Alkatra-Bold", size: 20)).foregroundColor(
              Color("LevelText"))
            Text("\(viewModel.score)").font(.custom("Alkatra-Bold", size: 24)).foregroundColor(
              Color("LevelText"))
          }
          Spacer()
          VStack(spacing: 0) {
            Text("TARGET").font(.custom("Alkatra-Bold", size: 20)).foregroundColor(
              Color("LevelText"))
            Text("\(viewModel.targetScore)").font(.custom("Alkatra-Bold", size: 24))
              .foregroundColor(Color("LevelText"))
          }
          Spacer()
          VStack(spacing: 0) {
            Text("MOVES").font(.custom("Alkatra-Bold", size: 20)).foregroundColor(
              Color("LevelText"))
            Text("\(viewModel.moves)").font(.custom("Alkatra-Bold", size: 24)).foregroundColor(
              Color("LevelText"))
          }
          Spacer()
          Button(action: { viewModel.isPaused = true }) {
            Image("Buttons-pause").resizable().frame(width: 50, height: 50)
          }
        }
        .padding(.top, 10)
        .padding(.horizontal, 30)

        Spacer()

        // GAME
        ZStack {
          SpriteView(scene: viewModel.scene, options: [.allowsTransparency])
            .frame(width: 350, height: 550)
        }
        .frame(width: 350, height: 550)

        Spacer()
      }
      .blur(radius: viewModel.isPaused ? 5 : 0)

      // --- PAUSE MENU ---
      if viewModel.isPaused {
        PauseModal(viewModel: viewModel, dismiss: dismiss)
      }

      // --- GAME OVER MENU ---
      if viewModel.showGameOverModal {
        GameOverModal(viewModel: viewModel, dismiss: dismiss)
      }
    }
    .navigationBarBackButtonHidden(true)
    .onAppear {
      viewModel.handleGameStart()
    }
  }
}

struct GameOverModal: View {
  @ObservedObject var viewModel: GameViewModel
  var dismiss: DismissAction

  var stars: Int {
    if viewModel.score >= viewModel.targetScore * 2 { return 3 }
    if viewModel.score >= Int(Double(viewModel.targetScore) * 1.5) { return 2 }
    if viewModel.score >= viewModel.targetScore { return 1 }
    return 0
  }

  var body: some View {
    ZStack {
      Color.black.opacity(0.6).ignoresSafeArea()

      VStack(spacing: 20) {
        if viewModel.gameOverCondition == .win {
          Text("LEVEL COMPLETE").font(.custom("Alkatra-Bold", size: 36)).foregroundColor(.green)
        } else {
          Text("GAME OVER").font(.custom("Alkatra-Bold", size: 36)).foregroundColor(.red)
        }

        HStack(spacing: 10) {
          ForEach(1...3, id: \.self) { i in
            Image(systemName: i <= stars ? "star.fill" : "star")
              .font(.system(size: 40))
              .foregroundColor(.yellow)
          }
        }
        .padding(.bottom, 10)

        Text("Score: \(viewModel.score)")
          .font(.custom("Alkatra-Bold", size: 28)).foregroundColor(.white)

        HStack(spacing: 30) {
          Button(action: { dismiss() }) {
            VStack {
              Image("Buttons-house").resizable().frame(width: 70, height: 70)
              Text("Map").font(.custom("Alkatra-Bold", size: 16)).foregroundColor(.white)
            }
          }

          if viewModel.gameOverCondition == .lose {
            Button(action: {
              viewModel.showGameOverModal = false
              viewModel.gameOverCondition = nil
              viewModel.moves = viewModel.currentLevel.moves
              viewModel.score = 0
              viewModel.handleGameStart()
              viewModel.scene.stateMachine.enter(WaitForInputState.self)
            }) {
              VStack {
                  Image("Buttons-arrow").resizable().frame(width: 70, height: 70)
                Text("Retry").font(.custom("Alkatra-Bold", size: 16)).foregroundColor(.white)
              }
            }
          }
        }
      }
      .padding(30)
      .background(
        RoundedRectangle(cornerRadius: 25)
          .fill(Color(red: 0.1, green: 0.1, blue: 0.15))
          .shadow(radius: 10)
          .overlay(
            RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.2), lineWidth: 2))
      )
      .padding(.horizontal, 40)
    }
  }
}

struct PauseModal: View {
  @ObservedObject var viewModel: GameViewModel
  var dismiss: DismissAction

  var body: some View {
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
