//
//  RegisterViewModel.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import Foundation
import Combine
import FirebaseAuth

class RegisterViewModel: ObservableObject {
    @Published var email = ""
    @Published var nickname = ""
    @Published var password = ""
    
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    var isValid: Bool {
        return !nickname.isEmpty && !email.isEmpty && password.count >= 6
    }
    
    func register() {
        guard isValid else {
            errorMessage = "Heslo je krátké."
            showError = true
            return
        }
        
        isLoading = true
        
        AuthenticationService.shared.register(email: email, pass: password) { [weak self] success in
                    guard let self = self else { return }
                    
                    if success {
                        guard let uid = Auth.auth().currentUser?.uid else {
                            self.errorMessage = "Chyba při registraci"
                            return
                        }
                        
                        let newUser = DBUser(id: uid, email: self.email, nickname: self.nickname)
                        
                        DatabaseService.shared.saveUser(user: newUser) { dbSuccess in
                            DispatchQueue.main.async {
                                self.isLoading = false
                                if dbSuccess {
                                } else {
                                    self.errorMessage = "Účet vytvořen, ale nepodařilo se uložit data."
                                    self.showError = true
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.errorMessage = AuthenticationService.shared.errorMessage
                            self.showError = true
                        }
                    }
                }
    }
}
