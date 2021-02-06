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
    
    func testMethod() {
        print("Hello from HomeCoordinator")
    }
}
