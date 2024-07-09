//
//  ContentView.swift
//  demo-ios
//
//  Created by Phearoen Phann on 7/7/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var networkManager = NetworkManager()
    @State private var page: Int = 1
    @State private var per: Int = 10
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
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
                                            HStack {
                                                Spacer()
                                                ProgressView()
                                                Spacer()
                                            }
                                            .frame(maxWidth: .infinity, alignment: .center)
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
                    if networkManager.hasMorePages {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onAppear() {
                            fetchMoreArticles()
                        }
                    }
                }
                .padding(.horizontal)
                .background(GeometryReader { geo -> Color in
                    DispatchQueue.main.async {
                        if geo.frame(in: .global).maxY < UIScreen.main.bounds.height {
                            fetchMoreArticles()
                        }
                    }
                    return Color.clear
                })
            }
            .navigationTitle("Articles")
            .onAppear {
                networkManager.fetchArticles(page: page, per: per)
            }
        }
    }
    
    private func fetchMoreArticles() {
        guard !networkManager.isLoading else { return }
        page += 1
        networkManager.fetchArticles(page: page, per: per)
    }
}

struct ContentView_Preview: PreviewProvider{
    static var previews: some View {
        ContentView().environmentObject(NetworkManager())
    }
}
