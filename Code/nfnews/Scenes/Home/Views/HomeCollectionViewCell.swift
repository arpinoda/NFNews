//
//  HomeCollectionViewCell.swift
//  nfnews
//
//  Created by Work on 2/16/21.
//

import UIKit

fileprivate struct Lang {
    static let untitledTitle = "No title provided"
    static let untitledDate = "No date"
}

class HomeCollectionViewCell: UICollectionViewCell {
    fileprivate let defaultImage = UIImage(named: "broken")
    
    @objc dynamic var selectedColor: UIColor?
    
    private lazy var imageView: HomeCollectionViewImageView = {
        return HomeCollectionViewImageView(image: self.defaultImage)
    }()
    
    var viewModel: HomeViewModelType?
    
    override var isSelected: Bool {
        didSet {
            if let selectedColor = selectedColor {
                self.contentView.backgroundColor = isSelected ? selectedColor : UIColor.clear
            }
        }
    }
    
    var title = HomeCollectionViewTitle()
    
    lazy var date: HomeCollectionViewSubtitle = {
        return HomeCollectionViewSubtitle(leadingReference: title.leadingAnchor, topReference: title.bottomAnchor)
    }()
    
    var viewData: HomeCollectionViewCellViewDataType? {
        didSet {
            self.title.text = viewData?.title ?? Lang.untitledTitle
            self.date.text = viewData?.prettyDate ?? Lang.untitledDate
            self.imageView.image = UIImage(named: "broken")
            
            guard let url = viewData?.imageURL else { return }
            
            if let image = imageCache[url.absoluteString] {
                // Image already exists in cache
                self.imageView.image = image
            } else {
                // Download image over network
                if let viewModel = viewModel {
                    viewModel.downloadFile(url: url) { (data) in
                        if let data = data {
                            DispatchQueue.main.async {
                                let image = UIImage(data: data)

                                // Cache the image
                                imageCache[url.absoluteString] = image
                                
                                self.imageView.image = image
                            }
                        }
                    }
                }
            }
        }
    }

    // Setting the cell's anchorPoint necessary for proper transform effect
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        self.layer.anchorPoint.x = 0.5
        self.layer.anchorPoint.y = 1
        
        //we need to adjust a center now
        self.center.y = self.center.y + layoutAttributes.size.height / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(title)
        self.contentView.addSubview(date)
        self.contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// Responsible for the roll effect seen upon scrolling
class RollingFadeLayout: UICollectionViewFlowLayout {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(scrollDirection:UICollectionView.ScrollDirection) {
        super.init()
        self.scrollDirection = scrollDirection
    }

    override func prepare() {
        setupLayout()
        super.prepare()
    }

    func setupLayout() {
        self.minimumLineSpacing = 0
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.y + collectionView.contentInset.top

        let targetRect = CGRect(x: 0, y: proposedContentOffset.y, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)

        guard let attributes = super.layoutAttributesForElements(in: targetRect) else {
            return .zero
        }
        
        attributes.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.y
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        })
       
        return CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y + offsetAdjustment)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect), let collectionView = self.collectionView else {
            return nil
        }
        
        var attributeCopy: UICollectionViewLayoutAttributes
        var attributesCopy = [UICollectionViewLayoutAttributes]()

        for attr in attributes {
            attributeCopy = attr.copy() as! UICollectionViewLayoutAttributes
            attributesCopy.append(attributeCopy)
            
            if attributeCopy.frame.intersects(rect) {
                
                // Calculate fraction complete
                let scrollY = collectionView.contentOffset.y + collectionView.contentInset.top
                let cellTop = attributeCopy.frame.minY
                let cellHeight = attributeCopy.frame.height
                let distanceUntilTop = scrollY - cellTop
                let fractionComplete = max(min(distanceUntilTop / cellHeight, 1), 0)
                
                // Opacity
                let fadeRate:CGFloat = 1
                let fade = 1 - (fractionComplete * fadeRate)
                attributeCopy.alpha = fade
                
                // Transform
                var transform = CATransform3DIdentity
                transform.m34 = -1.0 / 1000.0
                
                // Rotate
                let rotateRate:CGFloat = 0.5
                let degrees:CGFloat = fractionComplete * rotateRate
                let radians = CGFloat(Double.pi) * degrees
                transform = CATransform3DRotate(transform, radians, 1, 0, 0)
                
                // TranslateY
                let tY = pow((fractionComplete * rotateRate) - 1, 2)
                transform = CATransform3DTranslate(transform, 0, -tY, 0)
    
                attributeCopy.transform3D = transform
            }
            
        }
        
        return attributesCopy
    }
}
