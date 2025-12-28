//
//  MapViewModel.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 28.12.2025.
//

import SwiftUI
import Combine
import FirebaseAuth

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
    
    @Published var userMaxLevel: Int = 1
    @Published var userLives: Int = 5
    
    func fetchData() {
        print("currentUser \(Auth.auth().currentUser?.uid)")
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            DatabaseService.shared.fetchUser(uid: uid) { [weak self] user in
                guard let user = user else { return }
                print("Level: \(user.currentLevel)")
                print("Lives: \(user.lives)")
                DispatchQueue.main.async {
                    self?.userMaxLevel = user.currentLevel
                    self?.userLives = user.lives
                }
            }
        }
    
    func getXOffset(for level: Int) -> CGFloat {
        return CGFloat(sin(Double(level) * 0.8) * 80)
    }
}
