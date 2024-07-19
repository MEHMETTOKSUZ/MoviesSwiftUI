//
//  SignUpView.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 4.07.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import PhotosUI

struct SignUpView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var profileImage: UIImage? = nil
    @State private var showAlert = false
    @State private var alertMessage = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var navigateToHome = false
    @State private var showImagePicker = false

    var body: some View {
        VStack {
            Text("Yeni Hesap Oluştur")
                .font(.largeTitle)
                .padding()

            Button(action: {
                showImagePicker = true
            }) {
                if let profileImage = profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 5)
                } else {
                    LottieView(name: "profile")
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 5)
                }
            }
            .padding(.bottom, 20)

            TextField("Kullanıcı Adı", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("E-posta", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            SecureField("Şifre", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                signUp()
            }) {
                Text("Kayıt Ol")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)

            Spacer()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $profileImage)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Kayıt Durumu"), message: Text(alertMessage), dismissButton: .default(Text("Tamam"), action: {
                if navigateToHome {
                    isLoggedIn = true
                }
            }))
        }
    }

    func signUp() {
        guard let imageData = profileImage?.jpegData(compressionQuality: 0.4) else {
            alertMessage = "Profil resmi yüklenemedi."
            showAlert = true
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                alertMessage = "Kayıt Hatası: \(error.localizedDescription)"
                showAlert = true
                return
            }

            guard let authData = authDataResult else {
                alertMessage = "Kayıt başarısız oldu."
                showAlert = true
                return
            }

            let storageProfileReference = Storage.storage().reference().child("profile").child(authData.user.uid)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"

            storageProfileReference.putData(imageData, metadata: metadata) { storageMetaData, error in
                if let error = error {
                    alertMessage = "Profil resmi yüklenemedi: \(error.localizedDescription)"
                    showAlert = true
                    return
                }

                storageProfileReference.downloadURL { url, error in
                    if let metaImageUrl = url?.absoluteString {
                        if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                            changeRequest.photoURL = url
                            changeRequest.displayName = username
                            changeRequest.commitChanges { error in
                                if let error = error {
                                    alertMessage = "Profil güncellenemedi: \(error.localizedDescription)"
                                    showAlert = true
                                    return
                                } else {
                                    alertMessage = "Kayıt başarılı!"
                                    navigateToHome = true
                                    showAlert = true
                                }
                            }
                        }
                    } else {
                        alertMessage = "Profil resmi URL'si alınamadı."
                        showAlert = true
                    }
                }
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }

            provider.loadObject(ofClass: UIImage.self) { image, _ in
                self.parent.selectedImage = image as? UIImage
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}





