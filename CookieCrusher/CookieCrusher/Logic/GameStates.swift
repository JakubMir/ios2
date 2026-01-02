//
//  GameStates.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 02.01.2026.
//

internal import GameplayKit

class WaitForInputState: GKState {
  unowned let scene: GameScene

  init(scene: GameScene) {
    self.scene = scene
    super.init()
  }

  override func didEnter(from previousState: GKState?) {
    scene.isUserInteractionEnabled = true
  }

  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is AnimatingState.Type
  }
}

class AnimatingState: GKState {
  unowned let scene: GameScene

  init(scene: GameScene) {
    self.scene = scene
    super.init()
  }

  override func didEnter(from previousState: GKState?) {
    scene.isUserInteractionEnabled = false
    scene.resetSelection()
  }

  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is WaitForInputState.Type
  }
}

class GameOverState: GKState {
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return false
  }
}
