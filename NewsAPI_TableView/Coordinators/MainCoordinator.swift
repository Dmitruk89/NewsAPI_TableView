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
        print("App Coordinator Start")
        goToNewsListPage()
    }
    
    let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
    
    func goToNewsListPage(){
        print("load news list")
            let vc = storyboard.instantiateViewController(withIdentifier: "NewsListViewController") as! NewsListViewController
            let vm = NewsListViewModel.init()
            vm.coordinator = self
            vc.viewModel = vm
            navigationController.pushViewController(vc, animated: true)
        }
    
    func goToNewsDetailPage(newsUrl: URL){
            let vc = storyboard.instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
            let vm = NewsDetailViewModel.init(newsUrl: newsUrl)
            vm.coordinator = self
            vc.viewModel = vm
            navigationController.pushViewController(vc, animated: true)
        }
}
