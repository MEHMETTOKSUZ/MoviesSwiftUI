//
//  CartManager.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 1.07.2024.
//

import Foundation
import Combine

class CartManager: ObservableObject {
    
    static let shared = CartManager()
    
    private init() {}
    
    let key = "addedToCart"
    let userDefaults = UserDefaults.standard
    @Published var items: [Results] = []
    
    func load() {
        if let data = userDefaults.object(forKey: key) as? Data,
           let item = try? JSONDecoder().decode([Results].self, from: data) {
            self.items = item
        }
    }
    
    func get() -> [Results] {
        self.load()
        return items
    }
    
    func add(item: Results) {
        if let index = items.firstIndex(where: {$0.id == item.id}) {
            items.remove(at: index)
        } else {
            items.append(item)
        }
        savedCartItems()
        sendNotification()
    }
    
    func delete(for id: Int) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            items.remove(at: index)
        } else {
            print("error")
        }
        savedCartItems()
        sendNotification()
    }
    
    func savedCartItems() {
        if let data = try? JSONEncoder().encode(items) {
            userDefaults.set(data, forKey: key)
        }
    }
    
    func isInCart(item: Results) -> Bool {
        return items.contains {$0.id == item.id}
    }
    
    func calculateTotalPrice() -> (purchaseTotal: Double, rentTotal: Double) {
        let purchaseTotal = Double(items.count) * 2.99
        let rentTotal = Double(items.count) * 0.99
        return (purchaseTotal, rentTotal)
    }
    
    func removeAllItems() {
        items.removeAll()
        savedCartItems()
        sendNotification()
    }
    
    func sendNotification() {
      NotificationCenter.default.post(name: NSNotification.Name("newMovies"), object: nil)
    }
}

    

