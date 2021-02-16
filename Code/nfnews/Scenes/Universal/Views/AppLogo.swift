//
//  AppLogo.swift
//  nfnews
//
//  Created by Work on 2/16/21.
//

import UIKit

class AppLogo: UIImageView {
    
    public var topConstraint: NSLayoutConstraint!
    
    private var constraintsConfigured = false

    private lazy var padding: UIEdgeInsets = {
        return UIEdgeInsets(
            top: 0.07 * UI.screenHeight,
            left: HomeTableView.leftTrackWidth / 2,
            bottom: 0,
            right: 0
        )
    }()
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !constraintsConfigured {
            constraintsConfigured = true

            translatesAutoresizingMaskIntoConstraints = false
            leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: padding.left).isActive = true
            widthAnchor.constraint(equalToConstant: UI.screenWidth / 3).isActive = true

            topConstraint = self.topAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.topAnchor, constant: padding.top)
            topConstraint.isActive = true
        }
    }
    
    private func configureUI() {
        if let image = UIImage(named: "logo") {
            self.image = image
        } else {
            self.image = UIImage(named: "broken")
        }
        
        self.contentMode = .scaleAspectFit
        
        // Allows image to appear with tinted color
        self.image = self.image!.withRenderingMode(.alwaysTemplate)
    }
}

