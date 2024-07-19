//
//  CommentViewModel.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 11.07.2024.
//

import Foundation
import SwiftUI

class CommentViewModel: ObservableObject {
    
   @Published var comments: [Review] = []
    @Published var errorMessage: String? = nil
    
    func getCommentsData(selected: Int) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(selected)/reviews?api_key=\(LocaleKey.API_KEY)") else {
            print("Invalid URL")
            return
        }
        WebService.shared.fetchData(from: url) { (result: Result<ReviewsResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.comments = success.results
                case .failure(let failure):
                    self.errorMessage = failure.localizedDescription
                }
            }
        }
    }
  
}
