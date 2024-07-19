//
//  PaymentManager.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 2.07.2024.
//

import Foundation
import SwiftUI

class PaymentManager: ObservableObject {
    static let shared = PaymentManager()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    @Published var purchased: [Results] = []
    private let purchasedKey = "paymentSucces"
    
    func loadPurchasedItems() {
        if let data = userDefaults.data(forKey: purchasedKey),
           let items = try? JSONDecoder().decode([Results].self, from: data) {
            self.purchased = items
        }
    }
    
    func get() -> [Results] {
        self.loadPurchasedItems()
        return purchased
    }
    
    func add(item: Results) {
        if !purchased.contains(where: { $0.id == item.id }) {
            purchased.append(item)
            saveItems()
        }
    }
    
    func isPurchased(item: Results) -> Bool {
        loadPurchasedItems()
        return purchased.contains(where: { $0.id == item.id })
    }
    
    func purchase(item: Results, completion: @escaping (Bool) -> Void) {
        add(item: item)
        sendNotification()
        completion(true)
    }
    
    private func saveItems() {
        if let data = try? JSONEncoder().encode(purchased) {
            userDefaults.set(data, forKey: purchasedKey)
        }
    }
    
    private func sendNotification() {
        NotificationCenter.default.post(name: NSNotification.Name("newMovies"), object: nil)
    }
}



