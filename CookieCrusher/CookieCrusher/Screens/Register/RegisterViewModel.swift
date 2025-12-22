//
//  RegisterViewModel.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    var isValid: Bool {
        return !email.isEmpty && password.count >= 6 && password == confirmPassword
    }
    
    func register() {
        guard isValid else {
            errorMessage = "Hesla se neshodují nebo jsou krátká."
            showError = true
            return
        }
        
        isLoading = true
        
        AuthenticationService.shared.register(email: email, pass: password) { [weak self] success in
            DispatchQueue.main.async {
                self?.isLoading = false
                if !success {
                    self?.errorMessage = AuthenticationService.shared.errorMessage
                    self?.showError = true
                }
            }
        }
    }
}
