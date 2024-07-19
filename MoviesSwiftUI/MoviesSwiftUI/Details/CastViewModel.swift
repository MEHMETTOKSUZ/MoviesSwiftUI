//
//  CastViewModel.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 10.07.2024.
//

import Foundation

class CastViewModel: ObservableObject {
    
    @Published var errorMessage: String? = nil
    @Published var casting: [Cast] = []
    
    func getCastData(movieId: Int) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/credits?api_key=\(LocaleKey.API_KEY)") else {
            print("Invalid URL")
            return
        }
        WebService.shared.fetchData(from: url) { (result: Result<Credits, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.casting = success.cast
                case .failure(let failure):
                    self.errorMessage = failure.localizedDescription
                }
            }
        }
    }
    }
