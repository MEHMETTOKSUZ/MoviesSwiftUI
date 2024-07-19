//
//  LogInView.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 4.07.2024.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import Lottie

struct LogInView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 10) {
                LottieView(name: "animation")
                    .frame(width: 300, height: 300)

                Text("Movies App'a giriş yap")
                    .font(.headline)
                    .padding(.bottom, 20)

                NavigationLink(destination: SignUpView()) {
                    Text("E-mail ile kayıt ol")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                Text("YA DA")
                    .font(.headline)
                    .padding(.top, 20)

                Button(action: {
                    logInWithGoogle()
                }) {
                    Text("Google ile giriş yap")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(10)
                        .background(Color.red)
                        .cornerRadius(10)
                }

                Text("Eğer bir hesabınız varsa")
                    .font(.headline)
                    .padding(.top, 20)

                NavigationLink(destination: SignInView()) {
                    Text("E-mail ile giriş yap")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(10)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Giriş Durumu"), message: Text(alertMessage), dismissButton: .default(Text("Tamam"), action: {
                if isLoggedIn {
                    // Automatically navigate to HomeView
                }
            }))
        }
    }

    func logInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
            if let error = error {
                alertMessage = "Google Sign In Error: \(error.localizedDescription)"
                showAlert = true
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    alertMessage = "Google Sign In Error: \(error.localizedDescription)"
                    showAlert = true
                } else {
                    alertMessage = "Giriş başarılı!"
                    isLoggedIn = true
                    showAlert = true
                }
            }
        }
    }

    func getRootViewController() -> UIViewController {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return UIViewController()
        }
        return rootViewController
    }
}









