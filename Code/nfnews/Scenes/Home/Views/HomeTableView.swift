//
//  AppTableView.swift
//  nfnews
//
//  Created by Work on 2/16/21.
//

import UIKit

class AppTableViewTitle: AppRotatedLabel { }

class HomeTableView: UITableView {
    static let leftTrackWidth = UI.screenWidth * 0.21
    
    private var constraintsConfigured = false
    @objc dynamic var gradientColors: [UIColor]?
    private var gradientsConfigured = false
    private var leftBackground = UIView()
    private var rightBackground = UIView()
    
    private lazy var padding: UIEdgeInsets = {
        return UIEdgeInsets(top: 0.36 * UI.screenHeight, left: 0, bottom: 0, right: 0)
    }()
    
    init() {
        super.init(frame: .zero, style: .plain)
        self.configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !constraintsConfigured {
            constraintsConfigured = true
            self.translatesAutoresizingMaskIntoConstraints = false
            self.topAnchor.constraint(equalTo: superview!.topAnchor).isActive = true
            self.leadingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.leadingAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: superview!.bottomAnchor).isActive = true
            self.trailingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.trailingAnchor).isActive = true
            
            leftBackground.translatesAutoresizingMaskIntoConstraints = false
            leftBackground.topAnchor.constraint(equalTo: superview!.topAnchor).isActive = true
            leftBackground.leadingAnchor.constraint(equalTo: superview!.leadingAnchor).isActive = true
            leftBackground.bottomAnchor.constraint(equalTo: superview!.bottomAnchor).isActive = true
            leftBackground.widthAnchor.constraint(equalToConstant: HomeTableView.leftTrackWidth).isActive = true
            
            rightBackground.translatesAutoresizingMaskIntoConstraints = false
            rightBackground.topAnchor.constraint(equalTo: superview!.topAnchor).isActive = true
            rightBackground.bottomAnchor.constraint(equalTo: superview!.bottomAnchor).isActive = true
            rightBackground.trailingAnchor.constraint(equalTo: superview!.trailingAnchor).isActive = true
            rightBackground.leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: HomeTableView.leftTrackWidth).isActive = true
        }
        
        if let gradientColors = self.gradientColors, !gradientsConfigured, leftBackground.frame.width > 0, rightBackground.frame.width > 0 {
            self.gradientsConfigured = true

            // Left background
            let bannerTopColor = gradientColors[0]
            let bannerBottomColor = gradientColors[1]
            leftBackground.addGradientBackground(colors: bannerTopColor, bannerBottomColor, colorLocations: [0.8, 1.0])

            // Right background
            let leftColor = gradientColors[1]
            let rightColor = gradientColors[0]
            rightBackground.addGradientBackground(colors: leftColor, rightColor, colorLocations: [0.0, 1.0], angle: 90.0)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureUI() {
        self.backgroundView = UIView()
        self.backgroundView?.addSubview(leftBackground)
        self.backgroundView?.addSubview(rightBackground)

        self.allowsSelection = false
        self.showsVerticalScrollIndicator = false
        self.contentInset = padding
        let offset = CGPoint(x: 0, y: -padding.top)
        self.setContentOffset(offset, animated: false)
        self.register(cellClass: HomeTableViewCell.self)
        self.separatorStyle = .none
    }
}
