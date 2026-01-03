//
//  GameViewModel.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 28.12.2025.
//

import Combine
import FirebaseAuth
internal import GameplayKit
import SpriteKit
import SwiftUI

enum GameOverCondition {
  case win
  case lose
}

class GameViewModel: ObservableObject, GameSceneDelegate {
  @Published var score: Int = 0
  @Published var moves: Int = 0
  @Published var targetScore: Int = 0
  @Published var currentLevel: LevelData
  @Published var isPaused: Bool = false

  @Published var gameOverCondition: GameOverCondition? = nil
  @Published var showGameOverModal: Bool = false

  var level: Level
  var scene: GameScene

  init(levelData: LevelData) {
    self.currentLevel = levelData
    self.moves = levelData.moves
    self.targetScore = levelData.targetScore

    self.level = Level(data: levelData)

    self.scene = GameScene(size: CGSize(width: 350, height: 550))
    self.scene.scaleMode = .aspectFill

    self.scene.level = self.level
    self.scene.swipeDelegate = self
  }

  func handleGameStart() {
    let newCookies = level.shuffle()
    scene.addSprites(for: newCookies)
  }

  func swipeHandler(_ swap: Swap, completion: @escaping (Bool) -> Void) {
    level.performSwap(swap: swap)
    scene.animateSwap(swap) {
      let chains = self.level.detectMatches()
      if chains.isEmpty {
        self.level.performSwap(swap: swap)
        completion(false)
      } else {
        print("Matches found: \(chains.count)")
        self.handleMatches(chains)
        completion(true)

        DispatchQueue.main.async {
          self.moves -= 1

          if self.moves <= 0 {
            self.checkForGameOver()
          }
        }
      }
    }
  }

  func handleMatches(_ chains: Set<Chain>) {
    level.removeCookies(in: chains)

    scene.animateMatchedCookies(for: chains) {

      DispatchQueue.main.async {
        self.score += chains.count * 60
        self.checkForGameOver()
      }

      self.handleFallingCookies()
    }
  }

  func handleFallingCookies() {
    let columns = level.topUpCookies()

    scene.animateFallingCookies(columns: columns) {
      let newChains = self.level.detectMatches()

      if !newChains.isEmpty {
        self.handleMatches(newChains)
      } else {
        self.scene.stateMachine.enter(WaitForInputState.self)
        self.checkForGameOver()
      }
    }
  }

  func checkForGameOver() {
    if gameOverCondition != nil { return }

    if score >= targetScore {
      endGame(win: true)
      return
    }

    if moves <= 0 {
      endGame(win: false)
    }
  }

  func endGame(win: Bool) {
    scene.stateMachine.enter(GameOverState.self)

    if win {
      applyBonusPoints()
      gameOverCondition = .win
      saveProgressToFirebase()
    } else {
      gameOverCondition = .lose
      decreaseLivesInFirebase()
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.showGameOverModal = true
    }
  }

  func applyBonusPoints() {
    if moves > 0 {
      let bonusPerMove = currentLevel.targetScore / 10
      let totalBonus = moves * bonusPerMove

      print("Bonus! \(moves) moves left = +\(totalBonus) points")

      score += totalBonus
      moves = 0
    }
  }

  func calculateStars() -> Int {
    if score >= targetScore * 2 { return 3 }
    if score >= Int(Double(targetScore) * 1.5) { return 2 }
    if score >= targetScore { return 1 }
    return 0
  }

  private func saveProgressToFirebase() {
    guard let userId = Auth.auth().currentUser?.uid else { return }

    let nextLevel = currentLevel.id + 1
    let earnedStars = calculateStars()

    DatabaseService.shared.updateGameProgress(
      userId: userId,
      unlockedLevel: nextLevel,
      playedLevel: currentLevel.id,
      starsEarned: earnedStars,
      scoreToAdd: score,
    )
  }

  private func decreaseLivesInFirebase() {
    guard let userId = Auth.auth().currentUser?.uid else { return }

    DatabaseService.shared.decreaseLives(userId: userId) { remainingLives in
      print("Server potvrdil: Zbývá \(remainingLives) životů.")
    }
  }
}
