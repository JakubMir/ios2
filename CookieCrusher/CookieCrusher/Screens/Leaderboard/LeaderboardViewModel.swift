//
//  LeaderboardViewModel.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 28.12.2025.
//

import SwiftUI
import Combine
import FirebaseAuth

class LeaderboardViewModel: ObservableObject {
    @Published var topPlayers: [DBUser] = []
    @Published var isLoading = true
    
    // Načtení dat
    func loadLeaderboard() {
        isLoading = true
        DatabaseService.shared.fetchLeaderboard { [weak self] players in
            DispatchQueue.main.async {
                self?.topPlayers = players
                self?.isLoading = false
            }
        }
    }
    
    // Pomocná funkce: Jsem tento hráč já?
    // Používáme tvůj AuthenticationService.shared.user
    func isCurrentUser(userId: String) -> Bool {
        return AuthenticationService.shared.user?.uid == userId
    }
    
    // Pomocná funkce: Jaké je moje nejvyšší skóre?
    // Pokud jsem v TOP 10, vezme to z tabulky, jinak by to chtělo načíst z user profilu
    // Pro jednoduchost zatím zobrazíme skóre z Auth/DB logiky, pokud ho máme načtené jinde,
    // nebo ho můžeme vytáhnout z "me" v seznamu.
}
