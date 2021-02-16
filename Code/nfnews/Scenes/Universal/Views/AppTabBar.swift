//
//  CustomTabBar.swift
//  nfnews
//
//  Created by Work on 2/15/21.
//

import UIKit

class AppTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = AppTabBarController.tabBarHeight
        return sizeThatFits
    }
}
