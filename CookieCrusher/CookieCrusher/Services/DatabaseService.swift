//
//  DatabaseService.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import FirebaseFirestore
import Foundation

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
        "dateCreated": user.dateCreated,
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
      .order(by: "highestScore", descending: true)
      .limit(to: 50)
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

        let allUsers = documents.compactMap { doc -> DBUser? in
          let data = doc.data()
          var user = DBUser(
            id: data["id"] as? String ?? "",
            email: data["email"] as? String ?? "",
            nickname: data["nickname"] as? String ?? "Unknown"
          )
          user.highestScore = data["highestScore"] as? Int ?? 0
          return user
        }

        let registeredUsers = allUsers.filter { !$0.email.isEmpty && $0.highestScore > 0 }

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
      user.lives = data["lives"] as? Int ?? 5
      user.stars = data["stars"] as? [String: Int] ?? [:]

      completion(user)
    }
  }

  func updateGameProgress(
    userId: String, unlockedLevel: Int, playedLevel: Int, starsEarned: Int, scoreToAdd: Int,
    lives: Int
  ) {
    let userRef = db.collection("users").document(userId)

    db.runTransaction({ (transaction, errorPointer) -> Any? in
      let sfDocument: DocumentSnapshot
      do {
        try sfDocument = transaction.getDocument(userRef)
      } catch let fetchError as NSError {
        errorPointer?.pointee = fetchError
        return nil
      }

      let oldLevel = sfDocument.data()?["currentLevel"] as? Int ?? 1
      let oldStarsMap = sfDocument.data()?["stars"] as? [String: Int] ?? [:]

      let finalLevel = max(oldLevel, unlockedLevel)

      let levelKey = "\(playedLevel)"
      let oldStars = oldStarsMap[levelKey] ?? 0
      let finalStars = max(oldStars, starsEarned)

      transaction.updateData(
        [
          "currentLevel": finalLevel,
          "highestScore": FieldValue.increment(Int64(scoreToAdd)),
          "lives": lives,
          "stars.\(levelKey)": finalStars,
        ], forDocument: userRef)

      return nil

    }) { (object, error) in
      if let error = error {
        print("Chyba DB: \(error)")
      } else {
        print("DB OK: Level \(playedLevel) má nyní \(starsEarned) hvězd.")
      }
    }
  }

  func decreaseLives(userId: String, completion: @escaping (Int) -> Void) {
    let userRef = db.collection("users").document(userId)

    db.runTransaction({ (transaction, errorPointer) -> Any? in
      let sfDocument: DocumentSnapshot
      do {
        try sfDocument = transaction.getDocument(userRef)
      } catch let fetchError as NSError {
        errorPointer?.pointee = fetchError
        return nil
      }

      let currentLives = sfDocument.data()?["lives"] as? Int ?? 5

      let newLives = max(0, currentLives - 1)

      transaction.updateData(["lives": newLives], forDocument: userRef)

      return newLives

    }) { (object, error) in
      if let error = error {
        print("Chyba při odečítání životů: \(error)")
        completion(0)  // Fallback
      } else if let newLives = object as? Int {
        print("Život odečten. Zbývá: \(newLives)")
        completion(newLives)
      }
    }
  }
}
