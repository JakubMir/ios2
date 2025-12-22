//
//  LoginView.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                LoginBackground()
                
                if(viewModel.isLoading){
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                    }
                }
                else{
                    VStack {
                        Spacer()
                        
                        Text("CookieCrusher")
                            .font(.custom("Alkatra-Bold", size: 50))
                            .foregroundColor(.black)
                            .padding(.bottom, 40)
                        
                        // Form card
                        VStack(spacing: 10) {
                            if viewModel.showError {
                                Text(viewModel.errorMessage)
                                    .foregroundColor(.red)
                            }
                            LoginTextField(title: "Email", text: $viewModel.email)
                            
                            LoginTextField(title: "Password", text: $viewModel.password, isSecure: true)
                            
                            LoginButton(title: "Login", isValid:viewModel.isValid) {
                                viewModel.login()
                            }.padding(.top, 10)
                                .padding(.bottom, 10)
                                
                            
                            NavigationLink(destination: RegisterView()) {
                                Text("REGISTRATION")
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color("Secondary"))
                                    .cornerRadius(25)
                            }
                        }
                        .padding(15)
                        .frame(maxWidth: 380)
                        .background(.ultraThinMaterial)
                        .cornerRadius(30)
                        .padding(.horizontal, 20)
                        .shadow(radius: 5)
                        
                        Spacer()
                    }
                }
            }
        }
        .accentColor(Color("Primary"))
    }
}

#Preview {
    LoginView()
}
