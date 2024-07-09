//
//  Article.swift
//  demo-ios
//
//  Created by Phearoen Phann on 8/7/24.
//

import Foundation

struct Article: Codable, Identifiable {
  let id: Int
  let title: String
  let thumbnail: String
  let intro: String
  let content: String
  let date: String
  let categories: [Category]
  
  var categoryIds: [Int] {
    return categories.map { $0.id }
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case title
    case thumbnail = "eyecatch_img_url"
    case intro = "lead_text"
    case content = "main_text"
    case date = "published_at"
    case categories
  }
}
