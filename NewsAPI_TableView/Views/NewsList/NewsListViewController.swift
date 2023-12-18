//
//  NewsListViewController.swift
//  NewsAPI_TableView
//
//  Created by Mac on 08.12.2023.
//

import UIKit
import SafariServices

class NewsListViewController: UIViewController{
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return tableView
    }()
    
    var viewModel: NewsListViewModel = NewsListViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constant.title
        
        setupUI()
        setupViewModel()
        NSLayoutConstraint.activate(staticConstraints())
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func setupUI(){
        //tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
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
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
}

private extension NewsListViewController {
    enum Constant {
        static let title = "News app"
    }
}

extension NewsListViewController: NewsListViewModelDelegate {
    func viewModelDidUpdateData() {
        tableView.reloadData()
    }
}
