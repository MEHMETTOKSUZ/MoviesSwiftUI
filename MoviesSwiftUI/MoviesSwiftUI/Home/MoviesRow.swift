//
//  HomeViewModel.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 24.06.2024.
//

import SwiftUI

struct MovieRow: View {
    let movie: Results
    
    @State private var isFavorite: Bool = false
    
    var body: some View {
        HStack(alignment: .top) {
            if let posterPath = movie.poster_path {
                let imageUrl = "https://image.tmdb.org/t/p/w500" + posterPath
                ImageView(url: imageUrl, width: 80, height: 120, cornerRadius: 10)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(movie.original_title)
                    .font(.headline)
                RatingView(rating: movie.vote_average)
                Text(movie.overview)
                    .font(.caption2)
                    .multilineTextAlignment(.leading)
                    .lineLimit(4)
            }
            
            Spacer()
            
            Button(action: {
                toggleFavorite()
            }) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .font(.system(size: 20))
            }
            .buttonStyle(PlainButtonStyle())
            .contentShape(Rectangle())
        }
        .listStyle(PlainListStyle())
        .padding()
        .onAppear {
            isFavorite = FavoriteManager.shared.isFavorite(item: movie)
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
















