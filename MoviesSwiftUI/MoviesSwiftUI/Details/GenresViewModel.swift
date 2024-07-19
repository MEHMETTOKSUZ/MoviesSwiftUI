//
//  GenresViewModel.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 11.07.2024.
//

import Foundation
import SwiftUI

class MovieGenresViewModel: ObservableObject {
    
    @Published var errorMessage: String? = nil
   @Published var genres: [Genre] = []
    
    func getGenres(movieId: Int) {
        
        guard let genreUrl = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(LocaleKey.API_KEY)&language=en-US&append_to_response=genres")
        else {
            print("Invalid URL")
            return
        }
        
        WebService.shared.fetchData(from: genreUrl) { (result: Result<MovieGenres,Error>)  in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.genres = success.genres
                case .failure(let failure):
                    self.errorMessage = failure.localizedDescription
                }
            }
        }
    }
}
