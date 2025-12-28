//
//  MapViewModel.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 28.12.2025.
//

import SwiftUI
import Combine

struct World: Identifiable {
    let id: Int
    let backgroundName: String
    let levelRange: ClosedRange<Int>
}

class MapViewModel: ObservableObject {
    let worlds = [
        World(id: 3, backgroundName: "level_3", levelRange: 21...30),
        World(id: 2, backgroundName: "level_2", levelRange: 11...20),
        World(id: 1, backgroundName: "level_1", levelRange: 1...10)
    ]
    
    // Tady budeme později číst z DBUser
    @Published var userMaxLevel: Int = 5
    
    func getXOffset(for level: Int) -> CGFloat {
        return CGFloat(sin(Double(level) * 0.8) * 80)
    }
}
