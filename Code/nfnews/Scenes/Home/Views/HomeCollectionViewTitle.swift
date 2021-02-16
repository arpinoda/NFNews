//
//  AppCollectionViewTitle.swift
//  nfnews
//
//  Created by Work on 2/16/21.
//

import UIKit

class HomeCollectionViewTitle: AppConfigurableLabel {
    static var sizeMultiplier:CGFloat = 0.7
    
    private var constraintsConfigured = false
    
    private lazy var padding: UIEdgeInsets = {
        return UIEdgeInsets(top: 8, left: 0.5 * HomeTableView.leftTrackWidth, bottom: 0, right: 0)
    }()
    
    init() {
        super.init(frame: .zero)
        self.configureUI()
    }
    
    private func configureUI() {
        self.numberOfLines = 3
        self.lineBreakMode = .byTruncatingTail
        self.font = UIFont(size: .h3, weight: .ExtraBold)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !constraintsConfigured {
            constraintsConfigured = true
            let width = abs(superview!.frame.width * HomeCollectionViewTitle.sizeMultiplier - padding.left)
            
            self.translatesAutoresizingMaskIntoConstraints = false
            self.leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: padding.left).isActive = true
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
            self.topAnchor.constraint(equalTo: superview!.topAnchor, constant: padding.top).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
