//
//  SearchViewModel.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 28.06.2024.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    
    @Published var items: [Results] = []
    @Published var errorMessage: String? = nil
    
    
    func getSearchResults(query: String) {
        let endPoint = "https://api.themoviedb.org/3/search/movie?api_key=\(LocaleKey.API_KEY)&query=\(query)"
        fetchSearchMovies(from: endPoint)
    }
    
    private func fetchSearchMovies(from url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        WebService.shared.fetchData(from: url) { (result: Result<Movies, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.items = success.results
                case .failure(let failure):
                    self.errorMessage = failure.localizedDescription
                }
            }
        }
    }
    
}
