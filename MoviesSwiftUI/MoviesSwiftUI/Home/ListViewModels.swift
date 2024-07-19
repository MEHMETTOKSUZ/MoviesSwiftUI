//
//  ListViewModels.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 24.06.2024.
//


import Foundation
import SwiftUI

class MovieListViewModel: ObservableObject {
    @Published var movies: [Results] = []
    @Published var errorMessage: String? = nil
    
    func getNowPlayingMovies() {
        let endpoint = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(LocaleKey.API_KEY)&language=en-US&page=1"
        fetchMovies(from: endpoint)
    }
    
    private func fetchMovies(from url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        WebService.shared.fetchData(from: url) { (result: Result<Movies, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.movies = success.results
                case .failure(let failure):
                    self.errorMessage = failure.localizedDescription
                }
            }
        }
    }
}

