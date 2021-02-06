//
//  Strings.swift
//  nfnews
//
//  Created by Work on 2/6/21.
//

import UIKit

struct Strings {
    
    static var appBundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "(0)"
    static var appShortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    static var appVersion = "Version \(Strings.appShortVersion)"
}
