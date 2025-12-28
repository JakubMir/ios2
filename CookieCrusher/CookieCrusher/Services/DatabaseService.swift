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
    
    func checkOrCreateGuest(uid: String, completion: @escaping (Bool) -> Void) {
            let userDoc = db.collection("users").document(uid)
            
            userDoc.getDocument { snapshot, error in
                if let snapshot = snapshot, snapshot.exists {
                    print("Uživatel nalezen v DB.")
                    completion(true)
                } else {
                    print("Vytvářím nového hosta...")
                    
                    let newGuest = DBUser(id: uid, email: "", nickname: "Guest #\(uid)")
                    
                    self.saveUser(user: newGuest) { success in
                        completion(success)
                    }
                }
            }
        }
    
    func fetchLeaderboard(completion: @escaping ([DBUser]) -> Void) {
        db.collection("users")
            .order(by: "highestScore", descending: true) // 1. Seřadit podle skóre
            .limit(to: 50) // 2. Stáhnout jich víc (např. 50), abychom měli rezervu po odfiltrování hostů
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Chyba leaderboardu: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                
                // 3. Mapování na uživatele
                let allUsers = documents.compactMap { doc -> DBUser? in
                    let data = doc.data()
                    var user = DBUser(
                        id: data["id"] as? String ?? "",
                        email: data["email"] as? String ?? "", // Pokud pole chybí, je to prázdný string
                        nickname: data["nickname"] as? String ?? "Unknown"
                    )
                    user.highestScore = data["highestScore"] as? Int ?? 0
                    return user
                }
                
                // 4. FILTRACE: Chceme jen ty, co mají e-mail (nejsou to hosté)
                let registeredUsers = allUsers.filter { !$0.email.isEmpty }
                
                // 5. Vrátíme jen TOP 10 z těch vyfiltrovaných
                let top10 = Array(registeredUsers.prefix(10))
                
                completion(top10)
            }
    }

    func fetchUser(uid: String, completion: @escaping (DBUser?) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                completion(nil)
                return
            }
            
            var user = DBUser(
                id: data["id"] as? String ?? "",
                email: data["email"] as? String ?? "",
                nickname: data["nickname"] as? String ?? ""
            )
            user.highestScore = data["highestScore"] as? Int ?? 0
            user.currentLevel = data["currentLevel"] as? Int ?? 1
            
            completion(user)
        }
    }
}
