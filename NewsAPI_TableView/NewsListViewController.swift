//
//  NewsListViewController.swift
//  NewsAPI_TableView
//
//  Created by Mac on 08.12.2023.
//

import UIKit
import SafariServices

class NewsListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let newsService = NewsService()
    
    private var articles: [Article] = []
    private var viewModels = [NewsTableViewCellViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News app"
        setupUI()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        
        newsService.fetchNews { [weak self] newsResponse in
            DispatchQueue.main.async {
                if let newsResponse = newsResponse {
                    print(newsResponse.articles)
                    self?.articles = newsResponse.articles
                    self?.viewModels = newsResponse.articles.compactMap({
                        NewsTableViewCellViewModel(
                            title: $0.title ?? "no title",
                            description: $0.description ?? "no description",
                            imageUrl: URL(string: $0.urlToImage ?? "")
                        )
                    })
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                } else {
                    print("something went wrong")
                }
            }
        }
    }
    
    private func setupUI(){
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }

}

extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
                return UITableViewCell()
        }
        
        cell.configure(with: viewModels[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
