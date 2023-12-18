//
//  NewsListViewModel.swift
//  NewsAPI_TableView
//
//  Created by Mac on 14.12.2023.
//



import Foundation

protocol NewsListViewModelDelegate: AnyObject {
    func viewModelDidUpdateData()
}

final class NewsListViewModel {
    
    weak var delegate: NewsListViewModelDelegate?
    var coordinator: MainCoordinator?
    
    private let newsService = NewsService()
    private var articles: [Article] = [] {
        didSet {
            viewModels = articles.map{
                NewsTableViewCellViewModel(
                    title: $0.title ?? Constant.noTitle,
                    description: $0.description ?? Constant.noDescription,
                    imageUrl: URL(string: $0.urlToImage ?? ""),
                    newsUrl: URL(string: $0.url ?? "")
                )
            }
            delegate?.viewModelDidUpdateData()
        }
    }
    
    var viewModels = [NewsTableViewCellViewModel]()
    
    init() {
        fetchNews()
    }
    
    func fetchNews(){
        newsService.fetchNews { [weak self] newsResponse in
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

class NewsTableViewCellViewModel {
    let title: String
    let description: String
    let newsUrl: URL?
    let imageUrl: URL?
    var imageData: Data? = nil
    
    init(
        title: String,
        description: String,
        imageUrl: URL?,
        newsUrl: URL?
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
    }
}
