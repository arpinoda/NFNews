//
//  HomeCoordinator.swift
//  scratch
//
//  Created by Work on 2/15/21.
//

import UIKit

class HomeCoordinator: Coordinator {
  
    // MARK: - Properties
  
    let rootViewController: UITabBarController

    let rootNavigationController: UINavigationController = {
        let navVC = UINavigationController()
        navVC.tabBarItem = AppTabBarItems.home
        return navVC
    }()

    let apiClient: ApiClient
    var delegate: CoordinatorDelegate?

    // MARK: VM / VC's
    lazy var homeViewModel: HomeViewModel! = {
        let newsService = NewsApiService(apiClient: apiClient)
        let viewModel = HomeViewModel(service: newsService)
        viewModel.coordinatorDelegate = self
        return viewModel
    }()

    // MARK: - Coordinator
    init(rootViewController: UITabBarController, apiClient: ApiClient) {
        self.rootViewController = rootViewController
        self.apiClient = apiClient
    }

    override func start() {
        let homeVC = HomeController()
        homeVC.viewModel = homeViewModel
        rootNavigationController.setViewControllers([homeVC], animated: false)

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
extension HomeCoordinator {
    
    func goToHome() {
        self.rootNavigationController.dismiss(animated: true, completion: nil)
    }
    
    func goToHomeDetail(article: HomeCollectionViewCellViewDataType) {
        let vm = HomeDetailViewModel(viewData: article)
        vm.coordinatorDelegate = self
        
        let vc = HomeDetailController()
        vc.viewModel = vm
        
        let nc = UINavigationController(rootViewController: vc)
        self.rootNavigationController.present(nc, animated: true, completion: nil)
    }
}

// MARK: - Child coordinator callbacks
extension HomeCoordinator: CoordinatorDelegate {
    func didFinish(from coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
    }
}

// MARK: - ViewModel Callbacks
extension HomeCoordinator: HomeViewModelCoordinatorDelegate {
    func didSelectArticle(article: HomeCollectionViewCellViewDataType) {
        goToHomeDetail(article: article)
    }
}

extension HomeCoordinator: HomeDetailViewModelCoordinatorDelegate {
    func didCloseArticle() {
        goToHome()
    }
}
