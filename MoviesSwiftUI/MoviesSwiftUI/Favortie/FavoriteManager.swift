//
//  FavoriteManager.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 25.06.2024.
//


import Foundation

class FavoriteManager: ObservableObject {
    
    static let shared = FavoriteManager()
    private init() {}
    
    let favoriteKey = "FavoritesMovies"
    let userdefaults = UserDefaults.standard
    @Published var favorites: [Results] = []
    
    func loadFavoriteMovies() {
        if let data = userdefaults.object(forKey: favoriteKey) as? Data,
           let favorite = try? JSONDecoder().decode([Results].self, from: data) {
            self.favorites = favorite
        }
    }
    
    func get() -> [Results] {
        loadFavoriteMovies()
        return favorites
    }
    
    func add(item: Results) {
        if let index = favorites.firstIndex(where: { $0.id == item.id }) {
            favorites.remove(at: index)
            print("\(item.original_title) favorilerden kaldırıldı.")
        } else {
            favorites.insert(item, at: 0)
            print("\(item.original_title) favorilere eklendi.")
        }
        saveFavorites()
        sendNotification()
    }
    
    func delete(item: Results) {
        if let index = favorites.firstIndex(where: { $0.id == item.id }) {
            favorites.remove(at: index)
        } else {
            print("error")
        }
        saveFavorites()
        sendNotification()
    }
    
    func isFavorite(item: Results) -> Bool {
        return favorites.contains { $0.id == item.id }
    }
    
    func saveFavorites() {
        if let data = try? JSONEncoder().encode(favorites) {
            userdefaults.set(data, forKey: favoriteKey)
        }
    }
    
    func sendNotification() {
        NotificationCenter.default.post(name: NSNotification.Name("newMoviesAdded"), object: nil)
    }
}

