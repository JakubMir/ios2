//
//  LevelData.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 28.12.2025.
//

import Foundation

struct Chain: Hashable {
  var cookies: [GameCookie] = []

  enum ChainType: CustomStringConvertible {
    case horizontal
    case vertical

    var description: String {
      switch self {
      case .horizontal: return "Horizontal"
      case .vertical: return "Vertical"
      }
    }
  }

  var type: ChainType
}

let NumColumns = 9
let NumRows = 9

class Level {
  private var cookies = Array2D<GameCookie>(columns: NumColumns, rows: NumRows)
  private var tiles = Array2D<Bool>(columns: NumColumns, rows: NumRows)

  init(data: LevelData) {
    if let layout = data.layout {
      for (row, rowArray) in layout.enumerated() {
        for (col, value) in rowArray.enumerated() {
          if row < NumRows && col < NumColumns {
            tiles[col, row] = (value == 1)
          }
        }
      }
    } else {
      for row in 0..<NumRows {
        for col in 0..<NumColumns {
          tiles[col, row] = true
        }
      }
    }
  }

  func shuffle() -> Set<GameCookie> {
    return createInitialCookies()
  }

  private func createInitialCookies() -> Set<GameCookie> {
    var set: Set<GameCookie> = []
    for row in 0..<NumRows {
      for column in 0..<NumColumns {
        if tiles[column, row] == false { continue }
        var cookieType = 0
        var isValid = false
        while !isValid {
          cookieType = Int.random(in: 1...6)
          isValid = true
          if column >= 2,
            let c1 = cookies[column - 1, row], c1.cookieType == cookieType,
            let c2 = cookies[column - 2, row], c2.cookieType == cookieType
          {
            isValid = false
            continue
          }
          if row >= 2,
            let c1 = cookies[column, row - 1], c1.cookieType == cookieType,
            let c2 = cookies[column, row - 2], c2.cookieType == cookieType
          {
            isValid = false
            continue
          }
        }
        let cookie = GameCookie(column: column, row: row, cookieType: cookieType)
        cookies[column, row] = cookie
        set.insert(cookie)
      }
    }
    return set
  }

  func cookieAt(column: Int, row: Int) -> GameCookie? {
    guard column >= 0 && column < NumColumns && row >= 0 && row < NumRows else { return nil }
    return cookies[column, row]
  }

  func performSwap(swap: Swap) {
    let columnA = swap.cookieA.column
    let rowA = swap.cookieA.row
    let columnB = swap.cookieB.column
    let rowB = swap.cookieB.row

    cookies[columnA, rowA] = swap.cookieB
    swap.cookieB.column = columnA
    swap.cookieB.row = rowA

    cookies[columnB, rowB] = swap.cookieA
    swap.cookieA.column = columnB
    swap.cookieA.row = rowB
  }

  func detectMatches() -> Set<Chain> {
    var set: Set<Chain> = []

    for row in 0..<NumRows {
      var column = 0
      while column < NumColumns - 2 {
        if let cookie = cookies[column, row] {
          let matchType = cookie.cookieType

          if let c1 = cookies[column + 1, row], let c2 = cookies[column + 2, row],
            c1.cookieType == matchType && c2.cookieType == matchType
          {

            var chain = Chain(type: .horizontal)
            chain.cookies.append(cookie)
            chain.cookies.append(c1)
            chain.cookies.append(c2)

            var nextCol = column + 3
            while nextCol < NumColumns {
              if let nextCookie = cookies[nextCol, row], nextCookie.cookieType == matchType {
                chain.cookies.append(nextCookie)
                nextCol += 1
              } else {
                break
              }
            }

            set.insert(chain)
            column = nextCol
            continue
          }
        }
        column += 1
      }
    }

    for column in 0..<NumColumns {
      var row = 0
      while row < NumRows - 2 {
        if let cookie = cookies[column, row] {
          let matchType = cookie.cookieType

          if let c1 = cookies[column, row + 1], let c2 = cookies[column, row + 2],
            c1.cookieType == matchType && c2.cookieType == matchType
          {

            var chain = Chain(type: .vertical)
            chain.cookies.append(cookie)
            chain.cookies.append(c1)
            chain.cookies.append(c2)

            var nextRow = row + 3
            while nextRow < NumRows {
              if let nextCookie = cookies[column, nextRow], nextCookie.cookieType == matchType {
                chain.cookies.append(nextCookie)
                nextRow += 1
              } else {
                break
              }
            }

            set.insert(chain)
            row = nextRow
            continue
          }
        }
        row += 1
      }
    }

    return set
  }

  func removeCookies(in chains: Set<Chain>) {
    for chain in chains {
      for cookie in chain.cookies {
        cookies[cookie.column, cookie.row] = nil
      }
    }
  }
  func topUpCookies() -> [[GameCookie]] {
    var columns: [[GameCookie]] = []
    var cookieType: Int = 0

    for column in 0..<NumColumns {
      var array: [GameCookie] = []

      var holes = 0
      for row in 0..<NumRows {
        if tiles[column, row] == false { continue }

        if cookies[column, row] == nil {
          holes += 1
        } else if holes > 0 {
          let cookie = cookies[column, row]!
          cookies[column, row] = nil

          let newRow = row - holes
          cookie.row = newRow
          cookies[column, newRow] = cookie

          array.append(cookie)
        }
      }

      for i in 0..<holes {
        let newRow = (NumRows - holes) + i

        cookieType = Int.random(in: 1...6)

        let cookie = GameCookie(column: column, row: newRow, cookieType: cookieType)
        cookies[column, newRow] = cookie
        array.append(cookie)
      }

      if !array.isEmpty {
        columns.append(array)
      }
    }
    return columns
  }

  func isTileValid(column: Int, row: Int) -> Bool {
    guard column >= 0 && column < NumColumns && row >= 0 && row < NumRows else { return false }
    return tiles[column, row]!
  }
}
