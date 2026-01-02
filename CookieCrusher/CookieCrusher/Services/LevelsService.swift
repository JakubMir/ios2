//
//  LevelsService.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 28.12.2025.
//

import Foundation

class LevelsService {
    static let shared = LevelsService()
    
    private let customLevels: [Int: LevelData] = [:]
    
    private func generateLevel(id: Int) -> LevelData {
        let areaIndex = ((id - 1) / 10) % 3 + 1
        let bgName = "level_\(areaIndex)"
        
        let layoutIndex = ((id - 1) / 5) % LayoutPatterns.all.count
        let selectedLayout = LayoutPatterns.all[layoutIndex]
        
        let targetScore = 500 + (id * 200)
        let moves = 15 + (id / 5)
            
        return LevelData(
            id: id,
            moves: moves,
            targetScore: targetScore,
            backgroundName: bgName,
            layout: selectedLayout, // Zde předáme vybraný tvar
            gridSize: (9, 9)
            )
    }
    
    func getLevel(id: Int) -> LevelData {
        if let custom = customLevels[id] { return custom }
        return generateLevel(id: id)
    }
}
