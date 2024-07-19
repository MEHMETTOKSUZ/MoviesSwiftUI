//
//  WebService.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 24.06.2024.
//

import Foundation

class WebService {
    
    static let shared = WebService()
    private init() {}
    
    func fetchData<T: Codable>(from url: URL, completion: @escaping (Result<T,Error>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch let error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }.resume()
    }
}
