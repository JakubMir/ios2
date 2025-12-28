//
//  TopBarView.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 28.12.2025.
//

import SwiftUI

struct TopBarView: View {
    var lives: Int = 5
    var currency: Int = 150
    
    var body: some View {
        HStack {
            Button{
                
            }label: {
                Image("Buttons-shoping-trophy").resizable().scaledToFit().frame(width: 50, height: 70)
            }
            
            Spacer()
            
            // Lives
            ZStack{
                Image(systemName: "heart.fill")
                    .foregroundColor(.pink)
                    .font(.largeTitle)
                Text("\(lives)")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
            }.padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.5))
                .cornerRadius(20)
            
            Spacer()
            
            NavigationLink(destination: SettingsMenuView()) {
                Image("Buttons-setting").resizable().scaledToFit().frame(width: 50, height: 70)
            }
            
            
        }
        .padding(.horizontal)
        .background(Color("Primary"))
    }
}

#Preview{
    TopBarView()
}
