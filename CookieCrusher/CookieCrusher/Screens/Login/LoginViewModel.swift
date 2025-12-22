//
//  LoginViewModel.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    @Published var shouldDismiss = false
    
    var isValid: Bool {
        return !email.isEmpty && password.count >= 6
    }
    
    func login() {
        guard isValid else { return }
        
        isLoading = true
        
        AuthenticationService.shared.login(email: email, pass: password) { [weak self] success in
            DispatchQueue.main.async {
                self?.isLoading = false
                if success {
                    self?.shouldDismiss = true
                } else {
                    self?.errorMessage = AuthenticationService.shared.errorMessage
                    self?.showError = true
                }
            }
        }
    }
}
