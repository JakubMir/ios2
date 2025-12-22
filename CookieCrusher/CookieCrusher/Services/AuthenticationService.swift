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
    
    private init() {
        // Listen state change(login/logout) from Firebase
        Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
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
}
