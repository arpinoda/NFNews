//
//  UI.swift
//  nfnews
//
//  Created by Work on 2/8/21.
//

import UIKit

struct UI {
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height - UI.statusBarHeight
    static let screenScale = UI.screenWidth / UI.screenHeight
}
