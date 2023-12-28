//
//  NewsTableViewCellViewModel.swift
//  NewsAPI_TableView
//
//  Created by Руковичников Дмитрий on 25.12.23.
//

import Foundation

class NewsTableViewCellViewModel {
    let title: String
    let description: String
    let newsUrl: URL
    let imageUrl: URL
    var imageData: Data? = nil
    
    init(
        title: String,
        description: String,
        imageUrl: URL,
        newsUrl: URL
    ) {
        self.title = title
        self.description = description
        self.newsUrl = newsUrl
        self.imageUrl = imageUrl
    }
}
