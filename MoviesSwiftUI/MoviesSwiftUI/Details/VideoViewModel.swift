//
//  VideoViewModel.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 12.07.2024.
//

import Foundation
import SwiftUI

class VideosViewModel: ObservableObject {
    @Published var videos: [MovieVideo] = []
    @Published var errorMessage: String? = nil
    
    func getVideos(videoId: String) {
        guard let urlVideo = URL(string: "https://api.themoviedb.org/3/movie/\(videoId)?api_key=\(LocaleKey.API_KEY)&append_to_response=videos") else {
            print("Invalid URL")
            return
        }
        
        WebService.shared.fetchData(from: urlVideo) { (result: Result<MovieVideoDetails?, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let videoDetails):
                    if let results = videoDetails?.videos?.results {
                        self.videos = results
                    } else {
                        self.errorMessage = "No videos found."
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.errorMessage = "Failed to load videos."
                }
            }
        }
    }
}
