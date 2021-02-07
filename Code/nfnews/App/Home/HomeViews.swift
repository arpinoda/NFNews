//
//  HomeViews.swift
//  nfnews
//
//  Created by Work on 2/7/21.
//

import UIKit

class HomeTableView: UITableView {
    init() {
        super.init(frame: UIScreen.main.bounds, style: .plain)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
