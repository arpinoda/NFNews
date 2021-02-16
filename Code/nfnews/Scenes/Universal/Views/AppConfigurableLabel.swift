//
//  AppConfigurableLabel.swift
//  nfnews
//
//  Created by Work on 2/16/21.
//

import UIKit

class AppConfigurableLabel: UILabel {
    @objc dynamic var configurableTextColor: UIColor {
        get {
            return textColor
        }
        set {
            textColor = newValue
        }
    }
}
