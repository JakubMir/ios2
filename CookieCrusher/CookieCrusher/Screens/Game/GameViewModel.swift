//
//  GameViewModel.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 28.12.2025.
//

import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    let rows = 9
    let columns = 6
    
    @Published var cookies: [GameCookie] = []
    @Published var score: Int = 0
    @Published var moves: Int = 15
    @Published var isPaused: Bool = false
    
    init() {
        startNewGame()
    }
    
    func startNewGame() {
        score = 0
        moves = 15
        cookies = []
        generateGrid()
    }
    
    func generateGrid() {
        for r in 0..<rows {
            for c in 0..<columns {
                let randomType = Int.random(in: 1...6)
                let cookie = GameCookie(type: randomType, row: r, col: c)
                cookies.append(cookie)
            }
        }
    }
    
    func swapCookies(sourceIndex: Int, targetIndex: Int) {
        guard moves > 0 else { return }
        
        cookies.swapAt(sourceIndex, targetIndex)
        
        moves -= 1
        
        // TADY PŘÍŠTĚ: Zavoláme funkci checkForMatches()
    }
}
