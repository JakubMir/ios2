//
//  ContentView.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Log out"){
                AuthenticationService.shared.signOut()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
