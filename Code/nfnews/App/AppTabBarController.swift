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
        self.configureUI()
    }
    
    private func configureUI() {
        let iconWidth = 0.48 * UI.tabBarHeight
        object_setClass(self.tabBar, TallerTabBar.self)
        home.navigationController.tabBarItem = AppTabBarItem(icon: UIImage(named: "home"), iconWidth: iconWidth, tag: 0)
        search.tabBarItem = AppTabBarItem(icon: UIImage(named: "search"), iconWidth: iconWidth, tag: 1)
        favorite.tabBarItem = AppTabBarItem(icon: UIImage(named: "favorite"), iconWidth: iconWidth, tag: 2)
        profile.tabBarItem = AppTabBarItem(icon: UIImage(named: "profile"), iconWidth: iconWidth, tag: 3)
        
        self.view.addSubview(bottomBackground)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bottomBackground.translatesAutoresizingMaskIntoConstraints = false
        bottomBackground.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomBackground.bottomAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.topAnchor).isActive = true
        bottomBackground.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bottomBackground.topAnchor.constraint(equalTo: self.tabBar.safeAreaLayoutGuide.topAnchor, constant: -0.055 * UI.screenHeight).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let gradients = AppTabBarController.gradients, !gradientsConfigured, self.bottomBackground.frame.width > 0 {
            gradientsConfigured = true
            let leftColor = gradients[1]
            let rightColor = gradients[0]
            self.tabBar.addGradientBackground(colors: leftColor, rightColor, colorLocations: [0.3, 1.0], angle: 90.0)
            
            // Bottom background
            bottomBackground.addGradientBackground(colors: rightColor.withAlphaComponent(0), leftColor.withAlphaComponent(0.75))
            
            self.positionTabBarItems()
        }
    }
    
    private func positionTabBarItems() {
        if let items = tabBar.items {
            for (index, item) in items.enumerated() {
                let width = item.image!.size.width
                let y: CGFloat = 0.10 * width
                var x: CGFloat
                
                switch index {
                    case 0:
                        x = 0.33 * width
                        break
                    case 1:
                        x = 0.36 * width
                        break
                    case 2:
                        x = 0.08 * width
                        break
                    case 3:
                        x = -0.29 * width
                        break
                    default:
                        x = 0.00 * width
                }
                item.imageInsets = UIEdgeInsets(top: y, left: x, bottom: -y, right: -x)
            }
        }
    }
}
