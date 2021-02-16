//
//  AppTabBarItem.swift
//  nfnews
//
//  Created by Work on 2/15/21.
//

import UIKit

struct AppTabBarItems {
    
    static var favorite: AppTabBarItem {
        return AppTabBarItem(icon: UIImage(named: "favorite"), iconWidth: AppTabBarController.iconWidth, tag: 2)
    }
    
    static var home: AppTabBarItem {
        return AppTabBarItem(icon: UIImage(named: "home"), iconWidth: AppTabBarController.iconWidth, tag: 0)
    }
    
    static var profile: AppTabBarItem {
        return AppTabBarItem(icon: UIImage(named: "profile"), iconWidth: AppTabBarController.iconWidth, tag: 3)
    }
    
    static var search: AppTabBarItem {
        return AppTabBarItem(icon: UIImage(named: "search"), iconWidth: AppTabBarController.iconWidth, tag: 1)
    }
    
}

class AppTabBarItem: UITabBarItem {
    static var deselectedBackground: UIColor?
    static var deselectedForeground: UIColor?
    static var selectedBackground: UIColor?
    static var selectedForeground: UIColor?
    
    private var iconWidth: CGFloat
    private var icon: UIImage? {
        didSet {
            if let selectedBackground = AppTabBarItem.selectedBackground, let selectedForeground = AppTabBarItem.selectedForeground, let icon = self.icon, let selectedImage = UIImage(named: "selected") {
                
                guard let background = selectedImage.tinted(color: selectedBackground), let foreground = icon.tinted(color: selectedForeground), let merged = UIImage.combine(images: background, foreground)?.withRenderingMode(.alwaysOriginal), let resized = merged.resized(toWidth: self.iconWidth) else {
                    return
                }
                
                self.selectedImage = resized.withRenderingMode(.alwaysOriginal)
            }
            
            if let deselectedBackground = AppTabBarItem.deselectedBackground, let deselectedForeground = AppTabBarItem.deselectedForeground, let icon = self.icon, let selectedImage = UIImage(named: "selected") {
                
                guard let background = selectedImage.tinted(color: deselectedBackground), let foreground = icon.tinted(color: deselectedForeground), let merged = UIImage.combine(images: background, foreground)?.withRenderingMode(.alwaysOriginal), let resized = merged.resized(toWidth: self.iconWidth) else {
                    return
                }
                
                self.image = resized
            }
        }
    }
    
    init(icon: UIImage?, iconWidth: CGFloat, tag: Int) {
        self.iconWidth = iconWidth
        
        defer {
            self.icon = icon
            self.tag = tag
        }
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
