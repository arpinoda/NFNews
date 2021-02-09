//
//  Theme+Implementation.swift
//  nfnews
//
//  Created by Work on 2/8/21.
//

import UIKit

/// Create our palette
/// - assign asset catalog colorSets to strongly typed variables
private extension UIColor {
    struct palette {
        static var blueSkyDark: UIColor         { return #colorLiteral(red: 0.7450980392, green: 0.8039215686, blue: 0.8274509804, alpha: 1) }
        static var blueSkyLight: UIColor        { return #colorLiteral(red: 0.831372549, green: 0.8862745098, blue: 0.9058823529, alpha: 1) }
        static var blackPrimary: UIColor        { return #colorLiteral(red: 0.4117647059, green: 0.4117647059, blue: 0.4117647059, alpha: 1) }
        static var blackPrimaryDark: UIColor    { return #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1137254902, alpha: 1) }
        static var blackPrimaryLight:UIColor    { return #colorLiteral(red: 0.6352941176, green: 0.6352941176, blue: 0.6352941176, alpha: 1) }
        static var grayPrimary: UIColor         { return #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1) }
        static var grayPrimaryDark: UIColor     { return #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1) }
        static var grayPrimaryLight: UIColor    { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8470588235) }
    }
}

/// Implement a Light theme
public struct LightTheme: Theme {
    let backgroundGradients: [UIColor] = [UIColor.palette.grayPrimary, UIColor.palette.grayPrimaryDark]
    let collectionViewCellSelected: UIColor = UIColor.palette.grayPrimaryLight
    let collectionViewSubtitle: UIColor = UIColor.palette.blackPrimaryLight
    let collectionViewTitle: UIColor = UIColor.palette.blackPrimaryDark
    let headerBackground: [UIColor] = [UIColor.palette.blueSkyDark, UIColor.palette.blueSkyLight]
    let tableViewDragHandle: UIColor = UIColor.palette.blackPrimary
    let tableViewSeparator: UIColor = UIColor.palette.blackPrimary
    let tableViewTitle: UIColor = UIColor.palette.blackPrimary
    let logoTint: UIColor = UIColor.palette.blackPrimaryDark
    let tabBarItemSelectedBackground: UIColor = UIColor.palette.grayPrimaryLight
    let tabBarItemDeselectedBackground: UIColor = .clear
    let tabBarItemSelectedForeground: UIColor = UIColor.palette.blackPrimaryDark
    let tabBarItemDeselectedForeground: UIColor = UIColor.palette.blackPrimary
    let tabBarTint: UIColor = UIColor.palette.grayPrimaryDark
    
    func extend() {
        
    }
}

/// Implement a Dark theme
public struct DarkTheme {
    
}
