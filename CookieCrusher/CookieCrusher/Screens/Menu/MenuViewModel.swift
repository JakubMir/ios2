//
//  MenuViewModel.swift
//  CookieCrusher
//
//  Created by Václav Vizváry on 28.12.2025.
//

import SwiftUI
import FirebaseAuth
import Foundation
import Combine


enum SettingsViewState {
    case loading
    case authenticated
    case notAuthenticated
    case error(String)
}

class MenuViewModel: ObservableObject {
    @Published var state: SettingsViewState = .loading
    @Published var currentUser: User?
    @Published var isLoggedIn: Bool = false
    
    init() {
        checkAuthState()
    }
    
    // Kontrola stavu přihlášení
    func checkAuthState() {
        state = .loading
        
        if let user = Auth.auth().currentUser {
            self.currentUser = user
            self.isLoggedIn = true
            state = .authenticated
        } else {
            self.currentUser = nil
            self.isLoggedIn = false
            state = .notAuthenticated
        }
    }
    
    // Odhlášení uživatele
    func logOut() {
        AuthenticationService.shared.signOut()
        self.currentUser = nil
        self.isLoggedIn = false
        state = .notAuthenticated
    }
    
    // Navigace na účet (placeholder pro budoucí implementaci)
    func navigateToAccount() {
        // Zde bude logika pro navigaci na detail účtu
        print("Navigace na účet: \(currentUser?.email ?? "N/A")")
    }
    
    func navigateToMap() {
        NavigationLink("Map", destination: MapView())
    }
    
    
}
