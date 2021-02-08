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
        extend()
    }
}
