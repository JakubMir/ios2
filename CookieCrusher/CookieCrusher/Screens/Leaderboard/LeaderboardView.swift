//
//  LeaderboardView.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 28.12.2025.
//

import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // 1. Pozadí
            Color(red: 0.46, green: 0.84, blue: 0.88) // Tyrkysová #75D6E0
                .ignoresSafeArea()
            
            VStack {
                // 2. Horní lišta
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "house.fill")
                            .font(.title2)
                            .foregroundColor(Color(red: 0.96, green: 0.91, blue: 0.84))
                            .frame(width: 50, height: 50)
                            .background(Color(red: 0.42, green: 0.29, blue: 0.38)) // Tmavá
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(red: 0.2, green: 0.1, blue: 0.2), lineWidth: 2)
                            )
                    }
                    .padding()
                }
                
                Spacer()
                
                // 3. Nadpis
                Text("LEADERBOARD")
                    .font(.custom("Alkatra-Bold", size: 40))
                    .foregroundColor(.black)
                    .padding(.bottom, 20)
                
                // 4. Tabulka
                ZStack {
                    // Rámeček tabulky
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.96, green: 0.87, blue: 0.70)) // Béžová #F5DEB3
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(red: 0.42, green: 0.29, blue: 0.38), lineWidth: 5)
                        )
                        .shadow(radius: 10)
                    
                    if viewModel.isLoading {
                        ProgressView().tint(.black)
                    } else if viewModel.topPlayers.isEmpty {
                        Text("Zatím žádní hráči!")
                            .foregroundColor(.black.opacity(0.6))
                    } else {
                        // Seznam
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(Array(viewModel.topPlayers.enumerated()), id: \.element.id) { index, player in
                                    HStack {
                                        // A) Pořadí
                                        Text("\(index + 1).")
                                            .font(.custom("Alkatra-Bold", size: 20))
                                            .frame(width: 35, alignment: .leading)
                                        
                                        // B) Jméno
                                        Text(player.nickname)
                                            .font(.custom("Alkatra-Bold", size: 22))
                                            .lineLimit(1)
                                        
                                        Spacer()
                                        
                                        // C) Skóre
                                        Text("\(player.highestScore)")
                                            .font(.custom("Alkatra-Bold", size: 20))
                                    }
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                                    // Zvýraznění, pokud jsem to já
                                    .background(
                                        viewModel.isCurrentUser(userId: player.id)
                                        ? Color.white.opacity(0.6).cornerRadius(10) // Podbarvení pro mě
                                        : Color.clear.cornerRadius(10)
                                    )
                                }
                            }
                            .padding(.vertical, 20)
                        }
                    }
                }
                .frame(maxWidth: 350, maxHeight: 450)
                
                Spacer()
                Spacer()
            }
        }
        .onAppear {
            viewModel.loadLeaderboard()
        }
    }
}

#Preview {
    LeaderboardView()
}
