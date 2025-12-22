//
//  AuthenticationService.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import Foundation
import FirebaseAuth
import Combine

class AuthenticationService: ObservableObject {
    static let shared = AuthenticationService()
    
    @Published var user: User?
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    private init() {
        // Listen state change(login/logout) from Firebase
        Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
        }
    }
    
    func signInAnonymously(completion: @escaping (Bool) -> Void) {
        Auth.auth().signInAnonymously { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            self.errorMessage = ""
            completion(true)
        }
    }
    
    func login(email: String, pass: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            self.errorMessage = ""
            completion(true)
        }
    }
    
    func register(email: String, pass: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: pass) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            self.errorMessage = ""
            completion(true)
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
    
    func startSession(completion: @escaping () -> Void = {}) {
            if user != nil { return }
            
            isLoading = true
            
            Auth.auth().signInAnonymously { [weak self] result, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Chyba Auth: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                DatabaseService.shared.checkOrCreateGuest(uid: uid) { success in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        if !success {
                            print("Nepodařilo se ověřit uživatele v DB")
                        }
                    }
                    DispatchQueue.main.async {
                            self.isLoading = false
                            completion()
                        }
                }
            }
        }
}
