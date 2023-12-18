//
//  NewsDetailViewController.swift
//  NewsAPI_TableView
//
//  Created by Mac on 14.12.2023.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController {
    
    var webView: WKWebView!
    var viewModel: NewsDetailViewModel!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: viewModel.newsUrl))
    }

}
