//
//  NewsListViewModel.swift
//  NewsAPI_TableView
//
//  Created by Mac on 14.12.2023.
//



import Foundation
import UIKit

final class NewsListViewModel {
    
    var coordinator: MainCoordinator?
    var onDataUpdate: ((_ articles: [NewsTableViewCellViewModel]) -> Void)?
    
    private let newsService = NewsService()
    private var articles: [Article] = [] {
            didSet {
                viewModels = articles.compactMap { article in
                    if let title = article.title,
                       let description = article.description,
                       let imageURL = URL(string: article.urlToImage ?? ""),
                       let newsURL = URL(string: article.url ?? "") {
                        return NewsTableViewCellViewModel(
                            title: title,
                            description: description,
                            imageUrl: imageURL,
                            newsUrl: newsURL
                        )
                    } else {
                        return nil
                    }
                }
                onDataUpdate?(viewModels)
            }
        }
    
    var viewModels = [NewsTableViewCellViewModel]()
    var currentQuery: String?
    
    init() {
        fetchNews(query: Constant.initialQuery)
        }
    func fetchNews(query: String) {
        newsService.fetchNews(query: query) { [weak self] newsResponse in
            DispatchQueue.main.async {
                if let newsResponse = newsResponse {
                    self?.articles = newsResponse.articles
                    self?.currentQuery = query
                } else {
                    _ = NSError(domain: "NewsServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: Constant.defaultError])
                }
            }
        }
    }
}

    // MARK: Search functions

extension NewsListViewModel {
    public func updateSearchController(searchBarText: String?) {
        guard let query = searchBarText else {
            return
        }
        currentQuery = query
        fetchNews(query: query.lowercased())
    }
}

private extension NewsListViewModel {
    enum Constant {
        static let noTitle = "no title"
        static let noDescription = "no description"
        static let defaultError = "something went wrong"
        static let initialQuery = "Oscar"
    }
}
