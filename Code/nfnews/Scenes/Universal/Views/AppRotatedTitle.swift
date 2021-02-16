//
//  AppRotatedTitle.swift
//  nfnews
//
//  Created by Work on 2/16/21.
//

import UIKit

class AppRotatedLabel: AppConfigurableLabel {
    public var topLeftPoint: CGPoint!
    private var size: CGSize!
    
    private var constraintsConfigured = false
    
    init(radians: CGFloat, size: CGSize, topLeft: CGPoint) {
        self.size = size
        self.topLeftPoint = topLeft
        super.init(frame: .zero)
        transform = CGAffineTransform(rotationAngle: radians)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !constraintsConfigured {
            constraintsConfigured = true
            self.translatesAutoresizingMaskIntoConstraints = false
            
            self.leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: topLeftPoint.x).isActive = true
            self.topAnchor.constraint(equalTo: superview!.topAnchor, constant: topLeftPoint.y).isActive = true
            self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
            self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
