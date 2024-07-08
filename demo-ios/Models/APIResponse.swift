//
//  APIResponse.swift
//  demo-ios
//
//  Created by Phearoen Phann on 8/7/24.
//

import Foundation

struct APIResponse: Codable {
    let articles: [Article]
    let total_count: Int
    let total_pages: Int
}
