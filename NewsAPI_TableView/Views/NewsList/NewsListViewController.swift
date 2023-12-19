//
//  NewsListViewController.swift
//  NewsAPI_TableView
//
//  Created by Mac on 08.12.2023.
//

import UIKit
import SafariServices

class NewsListViewController: UIViewController{
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return tableView
    }()
    
    var viewModel: NewsListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchController()
        title = Constant.title
        
        setupUI()
        setupViewModel()
        NSLayoutConstraint.activate(staticConstraints())
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func setupUI(){
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func setupSearchController(){
        self.searchController.searchBar.delegate = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = Constant.searchPlaceholder
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func staticConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentsOf: [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        return constraints
    }

}

extension NewsListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            viewModel.fetchNews(query: searchText)
        }
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
        viewModel.coordinator?.goToNewsDetailPage(newsUrl: url)
    }
}

private extension NewsListViewController {
    enum Constant {
        static let title = "News app"
        static let searchPlaceholder = "What are you interested in?"
    }
}

extension NewsListViewController: NewsListViewModelDelegate {
    func viewModelDidUpdateData() {
        tableView.reloadData()
    }
}
