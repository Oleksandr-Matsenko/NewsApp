//
//  NewsModel.swift
//  NewsApp
//
//  Created by Alex Matsenko on 02.09.2024.
//

import Foundation

import Foundation

struct NewsResponce: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let content: String
    let urlToImage: String?
    let publishedAt: String
}

struct NewsEnvelope: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsResponce]
}

struct Source: Codable {
    let id: String?
    let name: String
}

