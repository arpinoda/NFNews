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
    var appCoordinator: AppCoordinator!
    let theme = LightTheme()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        theme.apply(for: application)
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
        
        return true
    }

}
