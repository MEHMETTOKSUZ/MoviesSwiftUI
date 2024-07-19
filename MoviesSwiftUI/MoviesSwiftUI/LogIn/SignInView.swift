//
//  SignInView.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 4.07.2024.
//

import SwiftUI
import FirebaseAuth

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var navigateToHome = false

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Giriş Yap")
                .font(.largeTitle)

            LottieView(name: "SignIn")
                .frame(width: 400, height: 400)

            TextField("E-posta", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            SecureField("Şifre", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                signIn()
            }) {
                Text("Giriş Yap")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)

            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Giriş Durumu"), message: Text(alertMessage), dismissButton: .default(Text("Tamam"), action: {
                if navigateToHome {
                    isLoggedIn = true
                }
            }))
        }
    }

    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = "Giriş Hatası: \(error.localizedDescription)"
                showAlert = true
                return
            }
            alertMessage = "Giriş başarılı!"
            navigateToHome = true
            showAlert = true
        }
    }
}




