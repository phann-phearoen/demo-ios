//
//  NetworkManager.swift
//  demo-ios
//
//  Created by Phearoen Phann on 8/7/24.
//

import Foundation

class NetworkManager: ObservableObject {
    @Published var articles: [Article] = []
    
    func fetchArticles() {
        guard let url = URL(string: "https://test-api.salvia-web.com/api/v1/articles/public_index") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
            }
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                let decodeResponse = try JSONDecoder().decode(ArticleWrapper.self, from: data)
                DispatchQueue.main.async {
                    self.articles = decodeResponse.articles
                    print("Articles fetched successfully")
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }
        task.resume()
    }
}
