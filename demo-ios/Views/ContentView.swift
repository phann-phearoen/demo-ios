//
//  ContentView.swift
//  demo-ios
//
//  Created by Phearoen Phann on 7/7/24.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var networkManager = NetworkManager()
  @StateObject private var categoryNetworkManager = CategoryNetworkManager()
  @State private var page: Int = 1
  @State private var per: Int = 10
  @State private var CPage: Int = 1
  @State private var CPer: Int = 5
  @State private var selectedCategoryIds: [Int] = []
  
  var body: some View {
    NavigationView {
      VStack {
        HStack {
          if selectedCategoryIds.count > 0 {
            Button(action: {
              selectedCategoryIds = []
            })
            {
              Text("X")
                .padding(.horizontal)
                .background(Color.pink)
                .foregroundColor(Color.white)
                .border(Color.pink)
                .cornerRadius(5)
            }
          }
          if categoryNetworkManager.isLoading && categoryNetworkManager.categories.count == 0 {
            ProgressView()
              .padding()
          } else {
            ScrollView(.horizontal, showsIndicators: false) {
              HStack {
                ForEach(categoryNetworkManager.categories) { category in
                  Button(action: {
                    toggleCategorySelection(category)
                  }) {
                    Text(category.title)
                      .padding(.horizontal)
                      .background(isCategorySelected(category) ? Color.white : Color.pink)
                      .foregroundColor(isCategorySelected(category) ? Color.pink : Color.white)
                      .border(Color.pink)
                      .cornerRadius(5)
                  }
                }
              }
              .background(GeometryReader { geo -> Color in
                DispatchQueue.main.async {
                  if geo.frame(in: .global).maxX < UIScreen.main.bounds.width {
                    fetchMoreCategories()
                  }
                }
                return Color.clear
              })
            }
          }
        }
        .padding(.horizontal)
        
        ScrollView {
          LazyVStack(spacing: 16) {
            if filteredArticles.count == 0 {
              Text("No articles")
            } else {
              ForEach(filteredArticles) { article in
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
      }
      .onAppear {
        networkManager.fetchArticles(page: page, per: per)
        categoryNetworkManager.fetchCategories(page: CPage, per: CPer)
      }
    }
  }
    
  private func fetchMoreArticles() {
    guard !networkManager.isLoading && networkManager.hasMorePages else { return }
    page += 1
    networkManager.fetchArticles(page: page, per: per)
  }
  
  private func fetchMoreCategories() {
    guard !categoryNetworkManager.isLoading && categoryNetworkManager.hasMorePages else { return }
    CPage += 1
    categoryNetworkManager.fetchCategories(page: CPage, per: CPer)
  }
  
  private func toggleCategorySelection(_ category: Category) {
    if let index = selectedCategoryIds.firstIndex(where: { $0 == category.id }) {
      selectedCategoryIds.remove(at: index)
    } else {
      selectedCategoryIds.append(category.id)
    }
  }
  
  private func isCategorySelected(_ category: Category) -> Bool {
    return selectedCategoryIds.contains(where: { $0 == category.id })
  }
  
  private var filteredArticles: [Article] {
    if selectedCategoryIds.isEmpty {
      return networkManager.articles
    } else {
      return networkManager.articles.filter { article in
        !Set(article.categoryIds).isDisjoint(with: selectedCategoryIds)
      }
    }
  }
}

struct ContentView_Preview: PreviewProvider{
  static var previews: some View {
    ContentView().environmentObject(NetworkManager())
  }
}
