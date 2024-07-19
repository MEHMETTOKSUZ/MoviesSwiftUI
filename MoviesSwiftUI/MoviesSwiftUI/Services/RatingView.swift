//
//  RatingView.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 27.06.2024.
//

import SwiftUI

struct RatingView: View {
    let rating: Double
    
    var body: some View {
        HStack {
            Image(systemName: "star.fill")
                .foregroundColor(.orange)
            Text(String(format: "%.1f / 10 IMDb", rating))
                .font(.footnote)
        }
    }
}

