//
//  NewsListViewController.swift
//  NewsAPI_TableView
//
//  Created by Mac on 08.12.2023.
//

import UIKit
import SafariServices

class NewsListViewController: UIViewController{
   
    private let tableView = UITableView()
    var viewModel: NewsListViewModel = NewsListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NewsListVCConstants.title
        
        setupUI()
        setupViewModel()
        viewModel.fetchNews()
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func setupUI(){
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        view.addSubview(tableView)
    }

}

extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
                return UITableViewCell()
        }
        
        cell.configure(with: viewModel.viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = viewModel.viewModels[indexPath.row]
        
        guard let url = article.newsUrl else {
            return
        }
        
        let vc = NewsDetailViewController(newsUrl: url)
        present(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

private extension NewsListViewController {
    enum NewsListVCConstants {
        static let title = "News app"
    }
}

extension NewsListViewController: NewsListViewModelDelegate {
    func viewModelDidUpdateData() {
        tableView.reloadData()
    }
}
