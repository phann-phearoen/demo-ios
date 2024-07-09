//
//  NetworkManager.swift
//  demo-ios
//
//  Created by Phearoen Phann on 8/7/24.
//

import Foundation

class NetworkManager: ObservableObject {
    @Published var articles: [Article] = []
    @Published var hasMorePages: Bool = true
    var isLoading: Bool = false
    
    func fetchArticles(page: Int, per: Int) {
        guard !isLoading else { return }
        isLoading = true
        
        var urlComponents = URLComponents(string: "https://test-api.salvia-web.com/api/v1/articles/public_index")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per", value: String(per))
        ]
        
        guard let url = urlComponents?.url else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer { self.isLoading = false }
            
            if let error = error {
                print("Error fetching data: \(error)")
            }
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                let decodeResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    print("Articles fetched successfully")
                    if page == 1 {
                        self.articles = decodeResponse.articles
                    } else {
                        self.articles.append(contentsOf: decodeResponse.articles)
                    }
                    self.hasMorePages = !decodeResponse.articles.isEmpty
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }
        task.resume()
    }
}
