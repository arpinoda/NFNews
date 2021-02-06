//
//  AppTabBarController.swift
//  nfnews
//
//  Created by Work on 2/6/21.
//

import UIKit

class AppTabBarController: UITabBarController {
    let home = HomeCoordinator()
    let search = SearchController()
    let favorite = FavoriteController()
    let profile = ProfileController()
    
    private var bottomBackground = UIView()
    private var gradientsConfigured = false
    
    static var gradients: [UIColor]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [home.navigationController, search, favorite, profile]
    }
}
