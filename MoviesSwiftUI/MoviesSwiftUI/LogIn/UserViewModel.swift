//
//  UserViewModel.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 10.07.2024.
//

import Foundation
import FirebaseAuth

class UserViewModel: ObservableObject {
    @Published var displayName: String = ""
    @Published var email: String = ""
    @Published var profileImageURL: URL?

    init() {
        fetchUserData()
    }

    func fetchUserData() {
        guard let user = Auth.auth().currentUser else { return }

        self.displayName = user.displayName ?? "Kullanıcı Adı"
        self.email = user.email ?? "E-posta"

        if let photoURL = user.photoURL {
            self.profileImageURL = photoURL
        } else {
            // Placeholder image if no profile image exists
            self.profileImageURL = URL(string: "https://example.com/placeholder.png")
        }
    }
}

