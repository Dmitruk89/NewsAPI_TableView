//
//  NewsDetailViewController.swift
//  NewsAPI_TableView
//
//  Created by Mac on 14.12.2023.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController {
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    var viewModel: NewsDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NSLayoutConstraint.activate(staticConstraints())
        guard let url = viewModel.newsUrl else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    private func staticConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
            
        constraints.append(contentsOf: [
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        return constraints
    }
    
    private func setupUI(){
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
    }

}
