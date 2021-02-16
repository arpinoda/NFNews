//
//  AppHeader.swift
//  nfnews
//
//  Created by Work on 2/16/21.
//

import UIKit

class HomeHeader: UIView {
    public var heightConstraint: NSLayoutConstraint!
    public var topConstraint: NSLayoutConstraint!
    public var bottomConstraint: NSLayoutConstraint!
    
    @objc dynamic var backgroundColors: [UIColor]?

    private var constraintsConfigured = false
    private var gradientConfigured = false
    private var defaultHeight = 0.17 * UI.screenHeight
    
    private lazy var padding: UIEdgeInsets = {
        return UIEdgeInsets(
            top: 0.145 * UI.screenHeight,
            left: HomeTableView.leftTrackWidth / 2,
            bottom: 0,
            right: 0
        )
    }()
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    private func configureUI() {
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !constraintsConfigured {
            constraintsConfigured = true
            translatesAutoresizingMaskIntoConstraints = false
            trailingAnchor.constraint(equalTo: superview!.trailingAnchor).isActive = true
            leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: padding.left).isActive = true
            topConstraint = topAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.topAnchor, constant: padding.top)
            topConstraint.isActive = true

            heightConstraint = heightAnchor.constraint(equalToConstant: defaultHeight)
            heightConstraint.isActive = true
        }

        guard let gradientColors = backgroundColors, !gradientConfigured && self.bounds.height > 0 && self.bounds.width > 0 else {
            return
        }
        
        gradientConfigured = true
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        layer.apply(angle: 45)
        layer.colors = gradientColors.map({ $0.cgColor })
        self.layer.addSublayer(layer)
    }
}
