//
//  RegisterView.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.dismiss) var dismiss // Pro tlačítko zpět
    
    var body: some View {
        ZStack {
            LoginBackground()
            
            VStack {
                Spacer()
                
                Text("CookieCrusher")
                    .font(.custom("Alkatra-Bold", size: 50))
                    .foregroundColor(.black)
                    .padding(.bottom, 20)
                
                // Form card
                VStack(spacing: 10) {
                    HStack {
                        Button(action: { dismiss() }) {
                            HStack(spacing: 5) {
                                Image(systemName: "chevron.left")
                                    .bold()
                                Text("LOGIN")
                                    .bold()
                            }
                            .foregroundColor(Color("Primary"))
                        }
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    // Form
                    LoginTextField(title: "Nickname", text: $viewModel.nickname)
                    
                    LoginTextField(title: "Email", text: $viewModel.email)
                    
                    LoginTextField(title: "Password", text: $viewModel.password, isSecure: true)
                    
                    
                    LoginButton(title: "Register", isPrimary: false) {
                        viewModel.register()
                    }.padding(.top, 10)
                        
                }
                .padding(15)
                .frame(maxWidth: 380)
                .background(.ultraThinMaterial)
                .cornerRadius(30)
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RegisterView()
}
