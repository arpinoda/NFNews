//
//  HomeCoordinator.swift
//  nfnews
//
//  Created by Work on 2/6/21.
//

import UIKit

class HomeCoordinator: Coordinator {
    internal var childCoordinators = [Coordinator]()
    internal var navigationController: UINavigationController
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        
        let homeVC = HomeController()
        homeVC.coordinator = self
        
        self.navigationController.viewControllers = [homeVC]
    }
    
    func showArticleDetail(url: URL) {
        let vc = HomeDetailController(url: url)
        vc.hidesBottomBarWhenPushed = true
        vc.coordinator = self
        let n = UINavigationController(rootViewController: vc)
        self.navigationController.present(n, animated: true, completion: nil)
    }
    
    func shareArticle(_ url: URL) {
        let ac = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.navigationController.present(ac, animated: true)
    }
}
