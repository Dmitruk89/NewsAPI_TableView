//
//  NewsListViewModel.swift
//  NewsAPI_TableView
//
//  Created by Mac on 14.12.2023.
//



import Foundation
import UIKit

protocol NewsListViewModelDelegate: AnyObject {
    func viewModelDidUpdateData()
}

final class NewsListViewModel {
    
    weak var delegate: NewsListViewModelDelegate?
    var coordinator: MainCoordinator?
    
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
                delegate?.viewModelDidUpdateData()
            }
    }
    
    var viewModels = [NewsTableViewCellViewModel]()
    
    init() {
        fetchNews(query: Constant.initialQuery)
    }
    
    func fetchNews(query: String){
        newsService.fetchNews(query: query) { [weak self] newsResponse in
            DispatchQueue.main.async {
                if let newsResponse = newsResponse {
                    self?.articles = newsResponse.articles
                } else {
                    print(Constant.defaultError)
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
        fetchNews(query: query.lowercased())
    }
}

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

private extension NewsListViewModel {
    enum Constant {
        static let noTitle = "no title"
        static let noDescription = "no description"
        static let defaultError = "something went wrong"
        static let initialQuery = "Oscar"
    }
}
