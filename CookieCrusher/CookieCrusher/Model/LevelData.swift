//
//  LevelData.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 28.12.2025.
//

import Foundation

struct LevelData: Identifiable, Equatable {
  let id: Int
  let moves: Int
  let targetScore: Int
  let backgroundName: String
  let layout: [[Int]]?
  let gridSize: (rows: Int, cols: Int)

  static func == (lhs: LevelData, rhs: LevelData) -> Bool {
    return lhs.id == rhs.id
  }
}
