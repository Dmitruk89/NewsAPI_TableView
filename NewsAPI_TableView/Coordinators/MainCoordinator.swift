//
//  MainCoordinator.swift
//  NewsAPI_TableView
//
//  Created by Mac on 15.12.2023.
//

import Foundation
import UIKit

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

class MainCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navController : UINavigationController) {
        self.navigationController = navController
    }
    
    func start() {
        goToNewsListPage()
    }
    
    let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
    
    func goToNewsListPage(){
        let newsListVC = storyboard.instantiateViewController(withIdentifier: "NewsListViewController") as!NewsListViewController
        let newsListVM = NewsListViewModel.init()
        newsListVM.coordinator = self
        newsListVC.viewModel = newsListVM
        navigationController.pushViewController(newsListVC, animated: true)
        }
    
    func goToNewsDetailPage(newsUrl: URL?){
        let newsDetailVC = storyboard.instantiateViewController(withIdentifier: "NewsDetailViewController") as!NewsDetailViewController
        let newsDetailVM = NewsDetailViewModel.init(newsUrl: newsUrl)
        newsDetailVM.coordinator = self
        newsDetailVC.viewModel = newsDetailVM
        navigationController.pushViewController(newsDetailVC, animated: true)
        }
}
