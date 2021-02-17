//
//  AppCollectionViewImageView.swift
//  nfnews
//
//  Created by Work on 2/16/21.
//

import UIKit

class HomeCollectionViewImageView: UIImageView {
    static var sizeMultiplier:CGFloat = 0.175
    
    private var constraintsConfigured = false
    
    override init(image: UIImage?) {
        super.init(image: image)
        self.configureUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private lazy var padding: UIEdgeInsets = {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !constraintsConfigured {
            constraintsConfigured = true
            self.trailingAnchor.constraint(equalTo: superview!.trailingAnchor).isActive = true
            self.widthAnchor.constraint(equalToConstant: superview!.frame.width * HomeCollectionViewImageView.sizeMultiplier).isActive = true
            self.heightAnchor.constraint(equalToConstant: superview!.frame.width * HomeCollectionViewImageView.sizeMultiplier).isActive = true
            self.topAnchor.constraint(equalTo: superview!.topAnchor, constant: padding.top).isActive = true
        }
        
    }
    
    private func configureUI() {
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = self.frame.width / 30
        self.clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
