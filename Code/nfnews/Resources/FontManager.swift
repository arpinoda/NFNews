//
//  FontManager.swift
//  nfnews
//
//  Created by Work on 2/7/21.
//

import Foundation
import UIKit

private let autoScaleSettings: AutoScaleSettings? = AutoScaleSettings()

private class AutoScaleSettings {
    let mostPopularScreenWidth: CGFloat = 375
    let maxScreenWidth: CGFloat = 460 //use to prevent huge font scaling on iPad
    let minScaleFactor: CGFloat = 0.93 //to protect scalling of very small sizes
}

extension UIFont {
    
    // MARK: - Configurations
    public enum Family: String {
        case System = ".SFUIText", Montserrat
        static let defaultFamily = Family.Montserrat
    }
    
    public enum Size: CGFloat {
        case h1 = 34, h2 = 16, h3 = 14, h4 = 12
    }

    enum CustomWeight: String {
        case Light, Regular, Medium, Bold, ExtraBold, Black
    }
    
    // MARK: - Utility
    /// Creates UIFont Name by composing Family and Weight strings.
    private static func stringName(_ family: Family, _ weight: CustomWeight) -> String {
        let fontName: String
       
        let fontWeight = weight.rawValue
        let fontfamily = family.rawValue
        
        fontName = "\(fontfamily)-\(fontWeight)"
        
        return fontName
    }
    
    // MARK: - Initializers
    convenience init(size: Size, weight: CustomWeight) {
        self.init(.defaultFamily, size, weight)
    }
    
    convenience init(_ family: Family, _ size: Size, _ weight: CustomWeight) {
        var sizeValue = size.rawValue
        
        if let autoScaleSettings = autoScaleSettings {
            let appropriateWidth = min(UIScreen.main.bounds.width,
            autoScaleSettings.maxScreenWidth)
            
            var ratio =  appropriateWidth / autoScaleSettings.mostPopularScreenWidth
            
            ratio = max(autoScaleSettings.minScaleFactor, ratio)
            
            sizeValue = round(ratio * sizeValue)
        }
        
        self.init(name: UIFont.stringName(family, weight), size: sizeValue)!
    }
}
