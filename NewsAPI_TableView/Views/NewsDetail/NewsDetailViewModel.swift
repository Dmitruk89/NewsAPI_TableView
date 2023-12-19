//
//  NewsDetailViewModel.swift
//  NewsAPI_TableView
//
//  Created by Mac on 15.12.2023.
//

import Foundation

final class NewsDetailViewModel {
    var newsUrl: URL?
    var coordinator: MainCoordinator?
    
    init?(newsUrl: URL?) {
        guard let newsUrl = newsUrl else {
            return nil
        }
        self.newsUrl = newsUrl
    }
}

