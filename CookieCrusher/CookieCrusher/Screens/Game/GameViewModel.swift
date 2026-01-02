//
//  GameViewModel.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 28.12.2025.
//

import Combine
import SwiftUI
import SpriteKit
internal import GameplayKit

class GameViewModel: ObservableObject, GameSceneDelegate {
    @Published var score: Int = 0
    @Published var moves: Int = 0
    @Published var targetScore: Int = 0
    @Published var currentLevel: LevelData
    @Published var isPaused: Bool = false
    
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
        
        // NEVOLÁME startNewGame() TADY!
        // Uděláme to až View "naskočí", aby seděly rozměry
    }
    
    // Tuto funkci zavoláme z .onAppear v GameView
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
                self.handleMatches(chains) // Spustíme řetězec událostí
                completion(true) // Swap byl úspěšný
                
                DispatchQueue.main.async {
                    self.moves -= 1
                }
            }
        }
    }
    
    // --- REKURZIVNÍ LOGIKA ---
    
    func handleMatches(_ chains: Set<Chain>) {
        // 1. Odstranit data
        level.removeCookies(in: chains)
        
        // 2. Animovat zmizení
        scene.animateMatchedCookies(for: chains) {
            
            // 3. Score
            DispatchQueue.main.async {
                self.score += chains.count * 60
            }
            
            // 4. Doplnit sušenky (Gravity)
            self.handleFallingCookies()
        }
    }
    
    func handleFallingCookies() {
        // Získáme sloupce s padajícími sušenkami
        let columns = level.topUpCookies()
        
        // Animujeme padání
        scene.animateFallingCookies(columns: columns) {
            // 5. REKURZE: Zkontrolujeme, jestli nevznikly nové shody
            let newChains = self.level.detectMatches()
            
            if !newChains.isEmpty {
                self.handleMatches(newChains) // Jedeme znovu
            } else {
                // Konec tahu, odemkneme vstup
                self.scene.stateMachine.enter(WaitForInputState.self)
            }
        }
    }
}
