//
//  LogInViewModel.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 9.07.2024.
//

import Foundation
import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            self?.isAuthenticated = user != nil
        }
    }
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
}

