//
//  ArticleView.swift
//  demo-ios
//
//  Created by Phearoen Phann on 8/7/24.
//

import SwiftUI

struct ArticleView: View {
    let article: Article
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(article.title)
                    .font(.title)
                    .padding(.horizontal)
                
                GeometryReader { geometry in
                    AsyncImage(url: URL(string: article.thumbnail)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .clipped()
                    } placeholder: {
                        ProgressView()
                    }
                }
                .frame(height: 150)
                
                Text(article.content)
            }
            .padding(.all)
        }
        .navigationTitle(article.title)
    }
}
