//
//  AccountViewModel.swift
//  CookieCrusher
//
//  Created by Václav Vizváry on 30.12.2025.
//

import SwiftUI
import FirebaseAuth
import Combine

class AccountViewModel: ObservableObject {
    @Published var user: DBUser?
    @Published var isLoading: Bool = true
    @Published var isAnonymous: Bool = true
    @Published var errorMessage: String = ""
    
    init() {
        fetchUserData()
    }
    
    func fetchUserData() {
        isLoading = true
        
        guard let currentUser = Auth.auth().currentUser else {
            isLoading = false
            return
        }
        
        // Check if user is anonymous
        isAnonymous = currentUser.isAnonymous
        
        // If anonymous, no need to fetch data
        if isAnonymous {
            isLoading = false
            return
        }
        
        // Fetch user data from database
        DatabaseService.shared.fetchUser(uid: currentUser.uid) { [weak self] dbUser in
            DispatchQueue.main.async {
                self?.user = dbUser
                self?.isLoading = false
                
                if dbUser == nil {
                    self?.errorMessage = "Failed to load user data"
                }
            }
        }
    }
    
    func refreshData() {
        fetchUserData()
    }
}
