//
//  DatabaseService.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import Foundation
import FirebaseFirestore

class DatabaseService {
    static let shared = DatabaseService()

    private let db = Firestore.firestore()
    
    private init() {}
    
    func saveUser(user: DBUser, completion: @escaping (Bool) -> Void) {
        do {
            let userData: [String: Any] = [
                "id": user.id,
                "email": user.email,
                "nickname": user.nickname,
                "currentLevel": user.currentLevel,
                "highestScore": user.highestScore,
                "lives": user.lives,
                "dateCreated": user.dateCreated
            ]
            
            db.collection("users").document(user.id).setData(userData) { error in
                if let error = error {
                    print("Chyba ukládání do DB: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Uživatel uložen do DB!")
                    completion(true)
                }
            }
        }
    }
}
