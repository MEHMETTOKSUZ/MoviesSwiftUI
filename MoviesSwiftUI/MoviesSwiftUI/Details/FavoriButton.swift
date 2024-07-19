//
//  FavoriButton.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 19.07.2024.
//

import Foundation
import SwiftUI

struct FavoriteButton: View {
    @Binding var isFavorite: Bool
    let movie: Results
    
    var body: some View {
        Button(action: {
            toggleFavorite()
        }) {
            Image(systemName: isFavorite ? "star.fill" : "star")
                .font(.system(size: 30))
                .foregroundColor(.gray)
        }
    }
    
    private func toggleFavorite() {
        if isFavorite {
            FavoriteManager.shared.delete(item: movie)
        } else {
            FavoriteManager.shared.add(item: movie)
        }
        isFavorite.toggle()
    }
}
