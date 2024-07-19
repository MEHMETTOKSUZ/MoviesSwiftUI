//
//  FavoriteMovieRow.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 26.06.2024.
//

import SwiftUI
import Kingfisher

struct FavoriteMovieRow: View {
    let movie: Results
    
    var body: some View {
          VStack(alignment: .leading) {
            if let posterPath = movie.poster_path {
                let imageUrl = "https://image.tmdb.org/t/p/w500" + posterPath
                ImageView(url: imageUrl, width: 180, height: 250, cornerRadius: 20)
              
            }
            }
        }
    }




