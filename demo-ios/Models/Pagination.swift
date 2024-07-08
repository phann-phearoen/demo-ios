//
//  Pagination.swift
//  demo-ios
//
//  Created by Phearoen Phann on 8/7/24.
//

import Foundation

struct Pagination: Codable {
    let currentPage: String
    let itemsPerPage: String
    let totalCount: String
    let totalPages: String
    
    enum CodingKeys: String, CodingKey {
        case currentPage
        case itemsPerPage
        case totalCount = "total_count"
        case totalPages = "total_pages"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currentPage = try container.decode(String.self, forKey: .currentPage)
        self.itemsPerPage = try container.decode(String.self, forKey: .itemsPerPage)
        self.totalCount = try container.decode(String.self, forKey: .totalCount)
        self.totalPages = try container.decode(String.self, forKey: .totalPages)
    }
}
