//
//  AppCoordinator.swift
//  scratch
//
//  Created by Work on 2/15/21.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    let window: UIWindow?
    
    lazy var rootViewController: AppTabBarController = {
        let tabController = AppTabBarController()
        self.setupChildCoordinators(tabController: tabController)
        
        return tabController
    }()
    
    let apiClient: ApiClient = {
        let apiClient = ApiClient(baseUrl: Strings.apiBaseURL)
        return apiClient
    }()

    // MARK: - Coordinator
    init(window: UIWindow?) {
        self.window = window
    }

    override func start() {
        guard let window = window else {
            return
        }

        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }

    override func finish() {
        apiClient.cancelPendingTasks()
    }

    private func setupChildCoordinators(tabController: AppTabBarController) {
        let homeCoordinator = HomeCoordinator(
            rootViewController: tabController,
            apiClient: apiClient
        )
        homeCoordinator.delegate = self
        homeCoordinator.start()
        addChildCoordinator(homeCoordinator)
        
        let searchCoordinator = SearchCoordinator(
            rootViewController: tabController,
            apiClient: apiClient
        )
        searchCoordinator.delegate = self
        searchCoordinator.start()
        addChildCoordinator(searchCoordinator)
        
        let favoriteCoordinator = FavoriteCoordinator(
            rootViewController: tabController,
            apiClient: apiClient
        )
        favoriteCoordinator.delegate = self
        favoriteCoordinator.start()
        addChildCoordinator(favoriteCoordinator)
        
        let profileCoordinator = ProfileCoordinator(
            rootViewController: tabController,
            apiClient: apiClient
        )
        profileCoordinator.delegate = self
        profileCoordinator.start()
        addChildCoordinator(profileCoordinator)
        
    }
}

extension AppCoordinator: CoordinatorDelegate {
    func didFinish(from coordinator: Coordinator) {
        removeChildCoordinator(self)
    }
}
