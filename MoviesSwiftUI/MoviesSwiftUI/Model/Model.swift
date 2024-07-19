//
//  Model.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 24.06.2024.
//

import SwiftUI
import Combine

struct Movies: Codable {
    
    var results: [Results]
}

struct Results: Codable, Equatable, Identifiable {
    let id: Int
    let original_title: String
    let overview: String
    let poster_path: String
    let release_date: String
    let vote_average: Double
    let genre_ids: [Int]
}

struct Credits: Codable {
    
    var cast: [Cast]
}

struct Cast: Codable , Equatable, Identifiable {
    let id: Int
    let name: String
    let character: String
    let profile_path: String?
    
}

struct MovieGenres: Codable {
    let genres: [Genre]
}

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}

struct ReviewsResponse: Codable {
    
    let results: [Review]
}

struct Review: Codable {
    let id: String
    let author: String
    let content: String
    let url: String
    let avatar_path: URL?
    let updated_at: String
    let rating: Double?
    
}

struct MovieVideoDetails: Codable {
    let id: Int
    let videos: MovieVideoResults?
}

struct MovieVideoResults: Codable {
    let results: [MovieVideo]
}

struct MovieVideo: Codable, Identifiable {
    let id: String
    let key: String
 
}










