//
//  AppCollectionViewSubtitle.swift
//  nfnews
//
//  Created by Work on 2/16/21.
//

import UIKit

class HomeCollectionViewSubtitle: AppConfigurableLabel {
    
    private var leadingReference: NSLayoutXAxisAnchor!
    private var topReference: NSLayoutYAxisAnchor!

    private var constraintsConfigured = false
    
    init(leadingReference: NSLayoutXAxisAnchor, topReference: NSLayoutYAxisAnchor) {
        self.leadingReference = leadingReference
        self.topReference = topReference
        
        super.init(frame: .zero)
        self.configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !constraintsConfigured {
            constraintsConfigured = true
            
            self.translatesAutoresizingMaskIntoConstraints = false
            self.leadingAnchor.constraint(equalTo: leadingReference).isActive = true
            self.trailingAnchor.constraint(equalTo: superview!.trailingAnchor).isActive = true
            self.topAnchor.constraint(equalToSystemSpacingBelow: topReference, multiplier: 1).isActive = true
        }
        
    }
    
    private func configureUI() {
        self.numberOfLines = 1
        self.lineBreakMode = .byTruncatingTail
        self.font = UIFont(size: .h4, weight: .Medium)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

