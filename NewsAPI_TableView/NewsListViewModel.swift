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

final class NewsListViewModel: ObservableObject {
    
    weak var delegate: NewsListViewModelDelegate?
    
    private let newsService = NewsService()
    private var articles: [Article] = [] {
        didSet {
            viewModels = articles.map{
                NewsTableViewCellViewModel(
                    title: $0.title ?? NewsListVMConstants.noTitle,
                    description: $0.description ?? NewsListVMConstants.noDescription,
                    imageUrl: URL(string: $0.urlToImage ?? ""),
                    newsUrl: URL(string: $0.url ?? "")
                )
            }
            delegate?.viewModelDidUpdateData()
        }
    }
    
    var viewModels = [NewsTableViewCellViewModel]()
    
    func fetchNews(){
        newsService.fetchNews { [weak self] newsResponse in
            DispatchQueue.main.async {
                if let newsResponse = newsResponse {
                    self?.articles = newsResponse.articles
                } else {
                    print(NewsListVMConstants.defaultError)
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
    enum NewsListVMConstants {
        static let noTitle = "no title"
        static let noDescription = "no description"
        static let defaultError = "something went wrong"
    }
}
