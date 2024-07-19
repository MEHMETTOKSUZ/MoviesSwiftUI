//
//  MovieHorizontalScrolView.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 27.06.2024.
//

import SwiftUI

struct MovieHorizontalScrollView: View {
    let movies: [Results]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                ForEach(movies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        HeaderView(movie: movie)
                            .frame(width: 125)
                            .padding(.vertical)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
