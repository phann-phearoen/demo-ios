//
//  Category.swift
//  demo-ios
//
//  Created by Phearoen Phann on 9/7/24.
//

import Foundation

struct Category: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
}

struct CategoryWrapper: Codable {
    let categories: [Category]
    let total_count: Int
    let total_pages: Int
}
