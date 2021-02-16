//
//  AppTabBarController.swift
//  nfnews
//
//  Created by Work on 2/6/21.
//

import UIKit

class AppTabBarController: UITabBarController {
    
    private var gradientBackground = UIView()
    private var gradientsConfigured = false
    
    static var gradients: [UIColor]?
    static let tabBarHeight: CGFloat = 0.132 * UI.screenHeight
    static let iconWidth: CGFloat = 0.48 * AppTabBarController.tabBarHeight
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    private func configureUI() {
        object_setClass(self.tabBar, AppTabBar.self)
        
        self.view.addSubview(gradientBackground)
        
        gradientBackground.translatesAutoresizingMaskIntoConstraints = false
        gradientBackground.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        gradientBackground.bottomAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.topAnchor).isActive = true
        gradientBackground.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        gradientBackground.topAnchor.constraint(equalTo: self.tabBar.safeAreaLayoutGuide.topAnchor, constant: -0.055 * UI.screenHeight).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let gradients = AppTabBarController.gradients, !gradientsConfigured, self.gradientBackground.frame.width > 0 {
            gradientsConfigured = true
            let leftColor = gradients[1]
            let rightColor = gradients[0]
            self.tabBar.addGradientBackground(colors: leftColor, rightColor, colorLocations: [0.3, 1.0], angle: 90.0)
            
            // Bottom background
            gradientBackground.addGradientBackground(colors: rightColor.withAlphaComponent(0), leftColor.withAlphaComponent(0.75))
            
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
