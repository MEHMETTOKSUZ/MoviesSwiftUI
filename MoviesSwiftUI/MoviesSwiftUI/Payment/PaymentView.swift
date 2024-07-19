//
//  PurchaseView.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 2.07.2024.
//

import SwiftUI

struct PaymentView: View {
    @State private var nameSurname: String = ""
    @State private var phoneNumber: String = ""
    @State private var email: String = ""
    @State private var identifierNumber: String = ""
    @State private var cardName: String = ""
    @State private var cardNumber: String = ""
    @State private var cardMonth: String = ""
    @State private var cardYear: String = ""
    @State private var cardCVV: String = ""
    @State private var isCheckmarkSelected: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertTitle: String = ""
    
    @ObservedObject private var cartManager = CartManager.shared
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Name Surname", text: $nameSurname)
                    TextField("Phone Number", text: $phoneNumber)
                    TextField("Email", text: $email)
                    TextField("Identifier Number", text: $identifierNumber)
                }
                
                Section(header: Text("Card Information")) {
                    TextField("Card Name", text: $cardName)
                    TextField("Card Number", text: $cardNumber)
                    TextField("Card Expiry Month", text: $cardMonth)
                    TextField("Card Expiry Year", text: $cardYear)
                    TextField("Card CVV", text: $cardCVV)
                }
                
                Section {
                    Toggle(isOn: $isCheckmarkSelected) {
                        Text("I agree to the terms and conditions")
                    }
                }
                
                Section(header: Text("Total Price")) {
                    Text("Total Purchase Price: $\(String(format: "%.2f", cartManager.calculateTotalPrice().purchaseTotal))")
                    Text("Total Rent Price: $\(String(format: "%.2f", cartManager.calculateTotalPrice().rentTotal))")
                }
                
                Button(action: {
                    if validateFields() {
                        savePurchasedData()
                        showAlert(with: "Success", message: "Purchase Successful!")
                        clearFields()
                    }
                }) {
                    Text("Confirm Purchase")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
        .onAppear {
            cartManager.load()
        }
    }
    
    private func validateFields() -> Bool {
        if nameSurname.isEmpty || phoneNumber.isEmpty || email.isEmpty || identifierNumber.isEmpty || cardName.isEmpty || cardNumber.isEmpty || cardMonth.isEmpty || cardYear.isEmpty || cardCVV.isEmpty {
            showAlert(with: "Error", message: "Please fill in all fields")
            return false
        }
        
        if !isCheckmarkSelected {
            showAlert(with: "Error", message: "You must agree to the terms and conditions")
            return false
        }
        
        return true
    }
    
    private func savePurchasedData() {
        if let data = UserDefaults.standard.data(forKey: "addedToCart"),
           let datas = try? JSONDecoder().decode([Results].self, from: data) {
            for item in datas {
                PaymentManager.shared.add(item: item)
            }
        }
        
        CartManager.shared.removeAllItems()
    }
    
    private func clearFields() {
        nameSurname = ""
        phoneNumber = ""
        email = ""
        identifierNumber = ""
        cardName = ""
        cardNumber = ""
        cardMonth = ""
        cardYear = ""
        cardCVV = ""
        isCheckmarkSelected = false
    }
    
    private func showAlert(with title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}








