//
//  SideMenu.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 27.06.2024.

import SwiftUI
import FirebaseAuth

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @State private var displayName: String = ""
    @State private var email: String = ""
    @State private var profileImageURL: URL? = nil
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var showingPurchasedView = false 
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let url = profileImageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 2)
                    case .failure:
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
            
            Text(displayName)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 10)
            
            Text(email)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 5) {
                MenuButton(title: "Satın Alınanlar", action: {
                    showingPurchasedView.toggle()
                    isShowing = false
                })
                MenuButton(title: "Ayarlar", action: { print("Ayarlar tıklandı") })
                MenuButton(title: "Hakkımda", action: { print("Hakkımda tıklandı") })
            }
            
            Button(action: {
                do {
                    try Auth.auth().signOut()
                    isLoggedIn = false
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
            }) {
                Text("Çıkış Yap")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showingPurchasedView) {
            PurchasedView()
                .edgesIgnoringSafeArea(.all) 
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemBackground))
        .onAppear {
            loadUserProfile()
        }
    }
    
    func loadUserProfile() {
        if let user = Auth.auth().currentUser {
            displayName = user.displayName ?? "Kullanıcı"
            email = user.email ?? ""
            profileImageURL = user.photoURL
        }
    }
}

struct MenuButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2)
        }
    }
}







