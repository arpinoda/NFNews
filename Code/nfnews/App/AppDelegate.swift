//
//  AppDelegate.swift
//  nfnews
//
//  Created by Work on 2/6/21.
//

import UIKit

// Global variable(s)
var imageCache = [String: UIImage]()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let theme = LightTheme()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        theme.apply(for: application)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let tabBarController = AppTabBarController()
        
        window?.rootViewController = tabBarController
        
        return true
    }

}

