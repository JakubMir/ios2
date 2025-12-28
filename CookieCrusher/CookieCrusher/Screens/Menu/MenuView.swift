//
//  MenuView.swift
//  CookieCrusher
//
//  Created by Václav Vizváry on 28.12.2025.
//

import SwiftUI

struct SettingsMenuView: View {
    
    @StateObject private var viewModel = MenuViewModel()
    @State private var navigateToMap = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                // Background image
                Image("menu_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top bar with home button
                    HStack {
                        Spacer()
                        
                        Button(action: {
                                                    navigateToMap = true
                                                }) {
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 0.85, green: 0.8, blue: 0.85))
                                        .frame(width: 50, height: 50)
                                    
                                    Image("Buttons-house")
                                        .font(.system(size: 24))
                                        .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.55))
                                }
                            }
                            .padding(.trailing, 120)
                            .padding(.top, 10)}
                    
                    Spacer()
                        .frame(height: 80)
                    
                    // Settings title
                    Text("SETTINGS")
                        .font(.custom("Alkatra-Bold", size: 50))
                        .foregroundColor(.black)
                        .padding(.bottom, 40)
                    
                    Spacer()
                        .frame(height: 100)
                    
                    // Account button
                    MenuButton(
                        title: "ACCOUNT",
                        action: { viewModel.navigateToAccount()} ,
                        backgroundColor: Color(red: 0.8, green: 0.95, blue: 0.8),
                        borderColor: Color(red: 0.4, green: 0.5, blue: 0.4)
                        
                    )
                    
                    Spacer()
                        .frame(height: 25)
                    
                    // Log out button
                    MenuButton(
                        title: "LOG OUT",
                        action: { viewModel.logOut() },
                        backgroundColor: Color(red: 0.98, green: 0.85, blue: 0.9),
                        borderColor: Color(red: 0.6, green: 0.4, blue: 0.5)
                    )
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $navigateToMap) {
                            MapView()
                        }
        }
    }
}



// Preview
struct SettingsMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenuView()
    }
}
