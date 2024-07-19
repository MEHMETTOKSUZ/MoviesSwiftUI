//
//  PurchasedView.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 15.07.2024.
//
import SwiftUI

struct PurchasedView: View {
    @ObservedObject var paymentManager = PaymentManager.shared
    
    var body: some View {
        NavigationView() {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(paymentManager.purchased) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            FavoriteMovieRow(movie: movie)
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                paymentManager.loadPurchasedItems()
            }
        }
        
    }
    
}


