//
//  DBUser.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import Foundation
import FirebaseFirestore

struct DBUser: Codable, Identifiable {
    let id: String
    let email: String
    let nickname: String
    var currentLevel: Int
    var highestScore: Int
    var lives: Int
    var dateCreated: Date
    var stars: [String: Int] = [:]
    
    init(id: String, email: String, nickname: String) {
        self.id = id
        self.email = email
        self.nickname = nickname
        self.currentLevel = 1
        self.highestScore = 0
        self.lives = 5
        self.dateCreated = Date()
    }
}
