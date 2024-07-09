//
//  CategoryNetworkManager.swift
//  demo-ios
//
//  Created by Phearoen Phann on 9/7/24.
//

import Foundation

class CategoryNetworkManager: ObservableObject {
  @Published var categories: [Category] = []
  var isLoading: Bool = false
  
  func fetchCategories(page: Int, per: Int) {
    guard !isLoading else { return }
    isLoading = true
    
    var urlComponents = URLComponents(string: "https://test-api.salvia-web.com/api/v1/categories")
    
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
        print("Error fetching categories: \(error)")
        return
      }
      guard let data = data else {
        print("No data received")
        return
      }
      
      do {
        let decodeResponse = try JSONDecoder().decode(CategoryWrapper.self, from: data)
        DispatchQueue.main.async {
          print("Categories fetched successfully")
          if page == 1 {
            self.categories = decodeResponse.categories
          } else {
            self.categories.append(contentsOf: decodeResponse.categories)
          }
        }
      } catch {
        print("Failed to decode JSON: \(error)")
      }
    }
    task.resume()
  }
}
