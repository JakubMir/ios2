//
//  CookieCrusherApp.swift
//  CookieCrusher
//
//  Created by Jakub Mir on 22.12.2025.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct CookieCrusherApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authService = AuthenticationService.shared
    
    @State private var isFirstLaunch = true
    
    var body: some Scene {
        WindowGroup {
            if authService.user != nil {
                ContentView()
                    .transition(.opacity)
            }
            else if isFirstLaunch {
                ZStack {
                    Image("menu_bg")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                    }
                }
                .onAppear {
                    authService.startSession {
                        withAnimation {
                            isFirstLaunch = false
                        }
                    }
                }
            }
            else {
                LoginView()
                    .transition(.opacity)
            }
        }
    }
}
