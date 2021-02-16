//
//  AppTableViewDragHandle.swift
//  nfnews
//
//  Created by Work on 2/16/21.
//

import UIKit

class HomeTableViewDragHandle: AppConfigurableLabel {
    
    private var constraintsConfigured = false
    
    lazy var padding: UIEdgeInsets = {
        let pl = 0.5 * HomeTableView.leftTrackWidth
        let pb = 0.1 * HomeTableViewCell.cellHeight
        var i = UIEdgeInsets(top: 0, left: pl, bottom: pb, right: 0)
        
        return i
    }()
    
    init() {
        super.init(frame: .zero)
        self.configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !constraintsConfigured {
            constraintsConfigured = true
            self.translatesAutoresizingMaskIntoConstraints = false
            self.centerXAnchor.constraint(equalTo: superview!.leadingAnchor, constant: padding.left).isActive = true
            self.bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: -padding.bottom).isActive = true
        }        
    }
    
    private func configureUI () {
        self.text = "⋮"
        self.font = UIFont(size: .h1, weight: .Light)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
