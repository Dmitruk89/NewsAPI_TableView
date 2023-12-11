//
//  News.swift
//  NewsAPI_TableView
//
//  Created by Mac on 08.12.2023.
//

import Foundation

struct Article: Decodable {
    struct Source: Decodable {
        let id: String?
        let name: String?
    }

    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct NewsResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
