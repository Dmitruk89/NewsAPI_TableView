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
    var newsUrl: URL
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print("news url \(newsUrl)")
        webView.load(URLRequest(url: self.newsUrl))
    }
    
    init(newsUrl: URL) {
        self.newsUrl = newsUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
