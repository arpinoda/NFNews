//
//  ProfileCoordinator.swift
//  nfnews
//
//  Created by Work on 2/16/21.
//

import UIKit

class ProfileCoordinator: Coordinator {
  
    // MARK: - Properties
  
    let rootViewController: UITabBarController

    let rootNavigationController: UINavigationController = {
        let navVC = UINavigationController()
        navVC.tabBarItem = AppTabBarItems.profile
        return navVC
    }()

    let apiClient: ApiClient
    var delegate: CoordinatorDelegate?

    // MARK: VM / VC's
   

    // MARK: - Coordinator
    init(rootViewController: UITabBarController, apiClient: ApiClient) {
        self.rootViewController = rootViewController
        self.apiClient = apiClient
    }

    override func start() {
        let vc = ProfileController()
        
        rootNavigationController.setViewControllers([vc], animated: false)

        if rootViewController.viewControllers == nil {
            rootViewController.setViewControllers([rootNavigationController], animated: false)
        } else {
            rootViewController.viewControllers!.append(rootNavigationController)
        }
    }

    override func finish() {
        // Clean up any view controllers on the navigation stack
        self.rootNavigationController.popToRootViewController(animated: false)
        // Tell api service to cancel any pending requests
        apiClient.cancelPendingTasks()
        // Call delegate to inform we are finished
        delegate?.didFinish(from: self)
    }
    
}

// MARK: - Navigation
extension ProfileCoordinator {
    
}

// MARK: - Child coordinator callbacks
extension ProfileCoordinator: CoordinatorDelegate {
    func didFinish(from coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
    }
}

// MARK: - ViewModel Callbacks

