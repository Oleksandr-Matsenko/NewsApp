//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Alex Matsenko on 02.09.2024.
//

import Foundation
struct NewsViewModel {
    let title: String
    let description: String
    let urlToImage: String?
    let name: String
    let author: String?
    let date: String
    let url: String?
    let content: String
    
    init(newsArticles: NewsResponce) {
        self.title = newsArticles.title
        self.author = newsArticles.author ?? "Unknown"
        self.description = newsArticles.description ?? ""
        self.urlToImage = newsArticles.urlToImage ?? "No image"
        self.name = newsArticles.source.name
        self.date = newsArticles.publishedAt
        self.url = newsArticles.url
        self.content = newsArticles.content
    }
    
}
