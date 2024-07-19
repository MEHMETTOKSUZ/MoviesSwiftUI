//
//  HeaderView.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 26.06.2024.
//

import Foundation
import SwiftUI
import Kingfisher

struct HeaderView: View {
    let movie: Results
    
    var body: some View {
        VStack(alignment: .leading) {
            if let posterPath = movie.poster_path {
                let imageUrl = "https://image.tmdb.org/t/p/w500" + posterPath
                ImageView(url: imageUrl, width: 120, height: 230, cornerRadius: 10).clipped()
               
            }
            Text(movie.original_title)
                .font(.headline)
                .lineLimit(3)
            HStack {
                Image(systemName: "star.fill").foregroundColor(.orange)
                Text(String(format: "%.1f / 10 IMDb", movie.vote_average))
                    .font(.footnote)
            }
           
        }
    }
}
