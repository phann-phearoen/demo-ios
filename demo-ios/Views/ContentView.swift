//
//  ContentView.swift
//  demo-ios
//
//  Created by Phearoen Phann on 7/7/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var networkManager = NetworkManager()
    @State private var selectedArticle: Article? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(networkManager.articles) { article in
                    VStack(alignment: .leading, spacing: 8) {
                        NavigationLink(destination: ArticleView(article: article)) {
                            VStack {
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
                                
                                Text(article.title)
                                    .font(.headline)
                                    .padding(.horizontal)
                                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.primary)
                            }
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 4, y: 4)
                        }
                        
                    }
                    .padding(.all)
                }
            }
            .navigationTitle("Articles")
            .onAppear {
                networkManager.fetchArticles(page: 1, per: 10)
            }
        }
    }
}

struct ContentView_Preview: PreviewProvider{
    static var previews: some View {
        ContentView().environmentObject(NetworkManager())
    }
}
