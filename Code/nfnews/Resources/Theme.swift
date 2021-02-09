//
//  Theme.swift
//  nfnews
//
//  Created by Work on 2/8/21.
//

import UIKit

/// Define all theme-able UI elements here
/// - promote convenience and extensibility
protocol Theme {
    /// Home Screen
    var collectionViewCellSelected: UIColor { get }
    var collectionViewSubtitle: UIColor { get }
    var collectionViewTitle: UIColor { get }
    var headerBackground: [UIColor] { get }
    var tableViewDragHandle: UIColor { get }
    var tableViewSeparator: UIColor { get }
    var tableViewTitle: UIColor { get }
    
    /// Global
    var backgroundGradients: [UIColor] { get }
    var logoTint: UIColor { get }
    var tabBarItemSelectedBackground: UIColor { get }
    var tabBarItemDeselectedBackground: UIColor { get }
    var tabBarItemSelectedForeground: UIColor { get }
    var tabBarItemDeselectedForeground: UIColor { get }
    var tabBarTint: UIColor { get }
    
    /// Convenience & Extensibility
    func apply(for application: UIApplication)
    func extend()
}

/// Apply theme to UI element properties
extension Theme {
    func apply(for application: UIApplication) {
        
        AppLogo.appearance().tintColor = logoTint
        
        if headerBackground.count == 1 {
            AppHeader.appearance().backgroundColor = headerBackground[0]
        } else if headerBackground.count > 1 {
            AppHeader.appearance().backgroundColors = headerBackground
        }
        
        AppTableView.appearance().gradientColors = backgroundGradients
        
        AppTableViewTitle.appearance().configurableTextColor = tableViewTitle
        
        AppTableViewDragHandle.appearance().configurableTextColor = tableViewDragHandle
        
        AppCollectionViewTitle.appearance().configurableTextColor = collectionViewTitle
        
        AppCollectionViewSubtitle.appearance().configurableTextColor = collectionViewSubtitle
        
        AppTabBarItem.deselectedForeground = self.tabBarItemDeselectedForeground
        AppTabBarItem.selectedBackground = self.tabBarItemSelectedBackground
        AppTabBarItem.selectedForeground = self.tabBarItemSelectedForeground
        AppTabBarItem.deselectedBackground = self.tabBarItemDeselectedBackground

        AppTabBarController.gradients = backgroundGradients
        UITabBar.appearance(whenContainedInInstancesOf: [AppTabBarController.self]).backgroundImage = UIImage()
        UITabBar.appearance(whenContainedInInstancesOf: [AppTabBarController.self]).barTintColor = tabBarTint
        UITabBar.appearance(whenContainedInInstancesOf: [AppTabBarController.self]).isTranslucent = false
        UITabBar.appearance(whenContainedInInstancesOf: [AppTabBarController.self]).clipsToBounds = true
        
        CollectionViewCell.appearance().selectedColor = self.collectionViewCellSelected
        
        TableViewCell.appearance().borderColor = tableViewSeparator
        
        extend()
    }
}
