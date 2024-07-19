//
//  CartMovieRow.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 1.07.2024.
//

import SwiftUI

struct CartMovieRow: View {
    let movie: Results
    
    var body: some View {
        VStack {
            if let posterPath = movie.poster_path {
                let imageUrl = "https://image.tmdb.org/t/p/w500" + posterPath
                ImageView(url: imageUrl, width: 320, height: 100, cornerRadius: 10)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(movie.original_title)
                    .font(.headline)
                Text(movie.release_date)
                    .font(.subheadline)
                RatingView(rating: movie.vote_average)
            }
            Spacer()
        }
    }
}
