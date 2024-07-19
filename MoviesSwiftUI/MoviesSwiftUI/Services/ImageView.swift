//
//  ImageView.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 27.06.2024.
//

import SwiftUI
import Kingfisher

struct ImageView: View {
    let url: String
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    
    var body: some View {
        KFImage(URL(string: url))
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .cornerRadius(cornerRadius)
            .clipped()
    }
}


