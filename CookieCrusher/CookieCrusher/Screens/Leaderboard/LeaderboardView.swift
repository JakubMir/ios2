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
        NavigationStack{
        ZStack {
            LoginBackground()
            
            VStack {
                HStack {
                    Spacer()
                    NavigationLink(destination: MapView()) {
                        Image("Buttons-house").resizable().scaledToFit().frame(width: 66, height: 70)
                    }
                    .padding(.trailing, 120)
                    .padding(.top, 10)
                }
                
                Spacer()
                
                Text("LEADERBOARD")
                    .font(.custom("Alkatra-Bold", size: 40))
                    .foregroundColor(.black)
                    .padding(.bottom, 20)
                

                ZStack {
                    // Rámeček tabulky
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("LeaderboardBg"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("LevelButtonBorder"), lineWidth: 5)
                        )
                    
                    if viewModel.isLoading {
                        ProgressView().tint(.black)
                    } else if viewModel.topPlayers.isEmpty {
                        Text("No players yet!")
                            .foregroundColor(.black.opacity(0.6))
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(Array(viewModel.topPlayers.enumerated()), id: \.element.id) { index, player in
                                    HStack {
                                        Text("\(index + 1).")
                                            .font(.custom("Alkatra-Bold", size: 20))
                                            .frame(width: 35, alignment: .leading)
                                        
                                        Text(player.nickname)
                                            .font(.custom("Alkatra-Bold", size: 22))
                                            .lineLimit(1)
                                        
                                        Spacer()
                                        
                                        Text("\(player.highestScore)")
                                            .font(.custom("Alkatra-Bold", size: 20))
                                    }
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 1)
                                    .background(
                                        viewModel.isCurrentUser(userId: player.id)
                                        ? Color.white.opacity(0.6).cornerRadius(10)
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
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LeaderboardView()
}
