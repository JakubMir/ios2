//
//  AccountView.swift
//  CookieCrusher
//
//  Created by Václav Vizváry on 30.12.2025.
//
import SwiftUI

struct AccountView: View {
    @StateObject private var viewModel = AccountViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var navigateToLogin = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background image
                Image("menu_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top bar with back button
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding()
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    
                    Spacer()
                        .frame(height: 40)
                    
                    // Account title
                    Text("ACCOUNT")
                        .font(.custom("Alkatra-Bold", size: 50))
                        .foregroundColor(.black)
                        .padding(.bottom, 40)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                    } else if viewModel.isAnonymous {
                        // Anonymous user - show login prompt
                        anonymousUserView
                    } else if let user = viewModel.user {
                        // Logged in user - show data
                        loggedInUserView(user: user)
                    } else {
                        // Error state
                        Text("Failed to load account data")
                            .foregroundColor(.red)
                            .font(.custom("Alkatra-Medium", size: 18))
                    }
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
        }
    }
    
    // MARK: - Anonymous User View
    private var anonymousUserView: some View {
        VStack(spacing: 30) {
            Image(systemName: "person.crop.circle.badge.questionmark")
                .font(.system(size: 80))
                .foregroundColor(.black.opacity(0.6))
            
            Text("You are playing as a Guest")
                .font(.custom("Alkatra-Bold", size: 26))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Text("Login to save your progress and compete on the leaderboard!")
                .font(.custom("Alkatra-Medium", size: 18))
                .foregroundColor(.black.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 80)
            
            Button(action: {
                navigateToLogin = true
            }) {
                Text("LOGIN NOW")
                    .font(.custom("Alkatra-Bold", size: 24))
                    .foregroundColor(.white)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color("Primary"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white, lineWidth: 3)
                            )
                    )
                    .shadow(radius: 5)
            }
            .padding(.top, 20)
        }
        .padding()
    }
    
    // MARK: - Logged In User View
    private func loggedInUserView(user: DBUser) -> some View {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dateString = dateFormatter.string(from: user.dateCreated)
        
        return ScrollView {
            VStack(spacing: 25) {
                // Profile Icon
                ZStack {
                    Circle()
                        .fill(Color("Primary"))
                        .frame(width: 100, height: 100)
                        .shadow(radius: 5)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 10)
                
                // Nickname
                Text(user.nickname)
                    .font(.custom("Alkatra-Bold", size: 32))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 30)
                
                // Email
                Text(user.email)
                    .font(.custom("Alkatra-Medium", size: 18))
                    .foregroundColor(.black.opacity(0.6))
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                
                // Stats Cards
                VStack(spacing: 15) {
                    // Current Level
                    statCard(
                        icon: "flag.fill",
                        title: "CURRENT LEVEL",
                        value: "\(user.currentLevel)",
                        backgroundColor: Color(red: 0.8, green: 0.95, blue: 0.8),
                        borderColor: Color(red: 0.4, green: 0.5, blue: 0.4)
                    )
                    
                    // Highest Score
                    statCard(
                        icon: "star.fill",
                        title: "HIGHEST SCORE",
                        value: "\(user.highestScore)",
                        backgroundColor: Color(red: 0.98, green: 0.9, blue: 0.7),
                        borderColor: Color(red: 0.7, green: 0.6, blue: 0.3)
                    )
                    
                    // Lives
                    statCard(
                        icon: "heart.fill",
                        title: "LIVES",
                        value: "\(user.lives)",
                        backgroundColor: Color(red: 0.98, green: 0.85, blue: 0.9),
                        borderColor: Color(red: 0.6, green: 0.4, blue: 0.5)
                    )
                    
                    // Member Since
                    statCard(
                        icon: "calendar",
                        title: "MEMBER SINCE",
                        value: dateString,
                        backgroundColor: Color(red: 0.85, green: 0.9, blue: 0.98),
                        borderColor: Color(red: 0.4, green: 0.5, blue: 0.6)
                    )
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
        }
    }
    
    // MARK: - Stat Card Component
    private func statCard(icon: String, title: String, value: String, backgroundColor: Color, borderColor: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(borderColor)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Alkatra-Bold", size: 14))
                    .foregroundColor(.black.opacity(0.6))
                
                Text(value)
                    .font(.custom("Alkatra-Bold", size: 22))
                    .foregroundColor(.black)
                   
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(borderColor, lineWidth: 3)
                )
        )
        .shadow(radius: 3)
    }
}

#Preview {
    AccountView()
}
