//
//  CartButton.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 19.07.2024.
//

import Foundation
import SwiftUI

struct CartButton: View {
    @Binding var isInCart: Bool
    let movie: Results
    
    var body: some View {
        Button(action: {
            toggleCartStatus()
        }) {
            Image(systemName: isInCart ? "cart.fill" : "cart")
                .font(.system(size: 30))
                .foregroundColor(.gray)
        }
    }
    
    private func toggleCartStatus() {
        if isInCart {
            CartManager.shared.delete(for: movie.id)
        } else {
            CartManager.shared.add(item: movie)
        }
        isInCart.toggle()
    }
}
