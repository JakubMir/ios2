//
//  GameCookie.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 28.12.2025.
//

import SpriteKit

class GameCookie: Hashable, CustomStringConvertible {
    var column: Int
    var row: Int
    let cookieType: Int // Cookie name in assets 1-6
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, cookieType: Int) {
        self.column = column
        self.row = row
        self.cookieType = cookieType
    }
    
    var description: String {
        return "type:\(cookieType) square:(\(column),\(row))"
    }
    
    // Hashable for Set usage
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }
    
    static func ==(lhs: GameCookie, rhs: GameCookie) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
    }
}
