//
//  GameCookie.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 28.12.2025.
//

import Foundation

struct GameCookie: Identifiable, Equatable {
    let id = UUID()
    var type: Int
    var row: Int
    var col: Int
    
    var isMatched: Bool = false
}
