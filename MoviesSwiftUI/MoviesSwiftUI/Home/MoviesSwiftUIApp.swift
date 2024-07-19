//
//  MoviesSwiftUIApp.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 24.06.2024.
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
struct MoviesSwiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                HomeView()
            } else {
                LogInView()
            }
        }
    }
}

