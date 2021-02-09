//
//  HomeViews.swift
//  nfnews
//
//  Created by Work on 2/7/21.
//

import UIKit

class AppCollectionViewImageView: UIImageView {
    
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
        
        self.trailingAnchor.constraint(equalTo: superview!.trailingAnchor).isActive = true
        self.widthAnchor.constraint(equalToConstant: superview!.frame.width * UI.collectionImageMultiplier).isActive = true
        self.heightAnchor.constraint(equalToConstant: superview!.frame.width * UI.collectionImageMultiplier).isActive = true
        self.topAnchor.constraint(equalTo: superview!.topAnchor, constant: padding.top).isActive = true
    }
    
    private func configureUI() {
        self.contentMode = .scaleAspectFit
        self.layer.cornerRadius = self.frame.width / 30
        self.clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AppCollectionViewSubtitle: AppConfigurableLabel {
    
    private var leadingReference: NSLayoutXAxisAnchor!
    private var topReference: NSLayoutYAxisAnchor!
    
    init(leadingReference: NSLayoutXAxisAnchor, topReference: NSLayoutYAxisAnchor) {
        self.leadingReference = leadingReference
        self.topReference = topReference
        
        super.init(frame: .zero)
        self.configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        // or leading reference
        self.leadingAnchor.constraint(equalTo: leadingReference).isActive = true
        self.trailingAnchor.constraint(equalTo: superview!.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalToSystemSpacingBelow: topReference, multiplier: 1).isActive = true
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

class AppCollectionViewTitle: AppConfigurableLabel {
    
    private lazy var padding: UIEdgeInsets = {
        return UIEdgeInsets(top: 8, left: 0.5 * AppTableView.leftTrackWidth, bottom: 0, right: 0)
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
        
        let width = abs(superview!.frame.width * UI.collectionTitleMultiplier - padding.left)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: padding.left).isActive = true
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.topAnchor.constraint(equalTo: superview!.topAnchor, constant: padding.top).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class AppConfigurableLabel: UILabel {
    @objc dynamic var configurableTextColor: UIColor {
        get {
            return textColor
        }
        set {
            textColor = newValue
        }
    }
}

class AppTableViewDragHandle: AppConfigurableLabel {
    
    lazy var padding: UIEdgeInsets = {
        let pl = 0.5 * AppTableView.leftTrackWidth
        let pb = 0.1 * TableViewCell.cellHeight
        var i = UIEdgeInsets(top: 0, left: pl, bottom: pb, right: 0)
        
        return i
    }()
    
    init() {
        super.init(frame: .zero)
        self.configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: superview!.leadingAnchor, constant: padding.left).isActive = true
        self.bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: -padding.bottom).isActive = true
        
    }
    
    private func configureUI () {
        self.text = "⋮"
        self.font = UIFont(size: .h1, weight: .Light)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class AppRotatedLabel: AppConfigurableLabel {
    public var topLeftPoint: CGPoint!
    private var size: CGSize!
    
    init(radians: CGFloat, size: CGSize, topLeft: CGPoint) {
        self.size = size
        self.topLeftPoint = topLeft
        super.init(frame: .zero)
        transform = CGAffineTransform(rotationAngle: radians)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: topLeftPoint.x).isActive = true
        self.topAnchor.constraint(equalTo: superview!.topAnchor, constant: topLeftPoint.y).isActive = true
        self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class AppBar: UITabBarItem {
     @objc dynamic var deselectedBackground: UIColor!
}

class AppTabBarItem: UITabBarItem {
    static var deselectedBackground: UIColor?
    static var deselectedForeground: UIColor?
    static var selectedBackground: UIColor?
    static var selectedForeground: UIColor?
    
    private var iconWidth: CGFloat
    private var icon: UIImage? {
        didSet {
            if let selectedBackground = AppTabBarItem.selectedBackground, let selectedForeground = AppTabBarItem.selectedForeground, let icon = self.icon, let selectedImage = UIImage(named: "selected") {
                
                guard let background = selectedImage.tinted(color: selectedBackground), let foreground = icon.tinted(color: selectedForeground), let merged = UIImage.combine(images: background, foreground)?.withRenderingMode(.alwaysOriginal), let resized = merged.resized(toWidth: self.iconWidth) else {
                    return
                }
                
                self.selectedImage = resized.withRenderingMode(.alwaysOriginal)
            }
            
            if let deselectedBackground = AppTabBarItem.deselectedBackground, let deselectedForeground = AppTabBarItem.deselectedForeground, let icon = self.icon, let selectedImage = UIImage(named: "selected") {
                
                guard let background = selectedImage.tinted(color: deselectedBackground), let foreground = icon.tinted(color: deselectedForeground), let merged = UIImage.combine(images: background, foreground)?.withRenderingMode(.alwaysOriginal), let resized = merged.resized(toWidth: self.iconWidth) else {
                    return
                }
                
                self.image = resized
            }
        }
    }
    
    init(icon: UIImage?, iconWidth: CGFloat, tag: Int) {
        self.iconWidth = iconWidth
        defer {
            self.icon = icon
            self.tag = tag
        }
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AppTableView: UITableView {
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
            leftBackground.widthAnchor.constraint(equalToConstant: AppTableView.leftTrackWidth).isActive = true
            
            rightBackground.translatesAutoresizingMaskIntoConstraints = false
            rightBackground.topAnchor.constraint(equalTo: superview!.topAnchor).isActive = true
            rightBackground.bottomAnchor.constraint(equalTo: superview!.bottomAnchor).isActive = true
            rightBackground.trailingAnchor.constraint(equalTo: superview!.trailingAnchor).isActive = true
            rightBackground.leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: AppTableView.leftTrackWidth).isActive = true
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
        self.register(cellClass: TableViewCell.self)
        self.separatorStyle = .none
    }
}

class AppTableViewTitle: AppRotatedLabel { }

class AppHeader: UIView {
    public var heightConstraint: NSLayoutConstraint!
    public var topConstraint: NSLayoutConstraint!
    public var bottomConstraint: NSLayoutConstraint!
    
    @objc dynamic var backgroundColors: [UIColor]?

    private var constraintsConfigured = false
    private var gradientConfigured = false
    private var defaultHeight = 0.165 * UI.screenHeight
    
    private lazy var padding: UIEdgeInsets = {
        return UIEdgeInsets(
            top: 0.145 * UI.screenHeight,
            left: AppTableView.leftTrackWidth / 2,
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


class AppLogo: UIImageView {
    
    public var topConstraint: NSLayoutConstraint!
    
    private var constraintsConfigured = false

    private lazy var padding: UIEdgeInsets = {
        return UIEdgeInsets(
            top: 0.07 * UI.screenHeight,
            left: AppTableView.leftTrackWidth / 2,
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

class TableViewCell: UITableViewCell {
    static var cellHeight:CGFloat = UI.screenHeight / 3.3
    var placeholderCell = CollectionViewCell()
    
    private var borderDrawn = false
    
    @objc dynamic var borderColor: UIColor?
    
    var model: TableViewCellModel? {
        didSet {
            self.groupTitle.text = model?.title ?? "Untitled category"
            self.groupTitle.sizeToFit()
        }
    }

    lazy var handleLabel = AppTableViewDragHandle()
    
    lazy var padding: UIEdgeInsets = {
        let pt = 0.18 * TableViewCell.cellHeight
        let pl = 0.5 * AppTableView.leftTrackWidth
        let pb = 0.4 * TableViewCell.cellHeight
        var i = UIEdgeInsets(top: pt, left: pl, bottom: pb, right: 0)
        
        return i
    }()
    
    lazy var groupTitle: AppTableViewTitle = {
        // Re-position and re-size label to accommodate rotation
        let offset = (AppTableView.leftTrackWidth / 2) - (TableViewCell.cellHeight / 2)
        let leading = offset + padding.bottom / 2
        let top = -offset
        let topLeft = CGPoint(x: leading, y: top)
        
        let width = TableViewCell.cellHeight - padding.bottom
        let height = AppTableView.leftTrackWidth
        let size = CGSize(width: width, height: height)
        
        let l = AppTableViewTitle(radians: -(.pi / 2), size: size, topLeft: topLeft)
        l.textAlignment = .right
        l.lineBreakMode = .byTruncatingTail
        l.font = UIFont(size: .h2, weight: .Medium)

        return l
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        cv.decelerationRate = UIScrollView.DecelerationRate.fast
        return cv
    }()
        
    lazy var flowLayout: RollingFadeLayout = {
        let fl = RollingFadeLayout(scrollDirection: .vertical)
        return fl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configureUI()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // TableViewCell bottom border - set as top border, hidden on first cell
        // Layer not rendering inside init()
        if !borderDrawn, let borderColor = borderColor {
            borderDrawn = true
            let border = CALayer()
            border.backgroundColor = borderColor.withAlphaComponent(0.15).cgColor
            
            let width = 1
            border.frame = CGRect(x: Int(AppTableView.leftTrackWidth + 1), y: 0, width: Int(self.frame.width), height: width)
            self.contentView.layer.addSublayer(border)
        }
    }
    
    private func configureUI() {
        self.backgroundColor = .clear
        
        self.contentView.addSubview(handleLabel)
        self.contentView.addSubview(groupTitle)
        collectionView.allowsSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
        self.contentView.addSubview(collectionView)
    }
    
    private func configureConstraints() {
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppTableView.leftTrackWidth).isActive = true
        collectionView.contentInset = UIEdgeInsets(top: padding.top, left: 0, bottom: 0, right: 0)
    }
}

extension TableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model?.items.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        guard let article = model?.items[indexPath.row] else {
            return
        }
        
        model?.homeViewModel.onArticleTapped(article.sourceURL)
    
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // Auto size cell depending upon text & image height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let item = self.model?.items[indexPath.row] {
            let approximatedWidth = abs(collectionView.frame.width * UI.collectionTitleMultiplier - padding.left)
            let size = CGSize(width: approximatedWidth, height: CGFloat.greatestFiniteMagnitude)
            
            // Image
            let imageSize = collectionView.frame.width * UI.collectionImageMultiplier
            
            // Title
            placeholderCell.title.text = item.title
            let titleSize = placeholderCell.title.sizeThatFits(size)
            // Date
            placeholderCell.date.text = item.prettyDate
            let dateSize = placeholderCell.date.sizeThatFits(size)
            
            let paddingBottom = UI.collectionLineSpacingMultiplier * collectionView.frame.height
            
            let summedText = ceil(titleSize.height + dateSize.height * 2.6)
            let maxHeight = max(imageSize, summedText) + paddingBottom
           
            
            let result = CGSize(width: collectionView.frame.width, height: maxHeight)
            
            return result
        }
        
        return CGSize(width: collectionView.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView,
               layout collectionViewLayout: UICollectionViewLayout,
               insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell, let cellModel = model?.items[indexPath.row] {
            cell.model = cellModel
            return cell
        }
        return UICollectionViewCell()
    }
    
}

class CollectionViewCell: UICollectionViewCell {
    fileprivate let defaultImage = UIImage(named: "broken")
    
    @objc dynamic var selectedColor: UIColor?
    
    private lazy var imageView: AppCollectionViewImageView = {
        return AppCollectionViewImageView(image: self.defaultImage)
    }()
    
    override var isSelected: Bool {
        didSet {
            if let selectedColor = selectedColor {
                self.contentView.backgroundColor = isSelected ? selectedColor : UIColor.clear
            }
        }
    }
    
    var title = AppCollectionViewTitle()
    
    lazy var date: AppCollectionViewSubtitle = {
        return AppCollectionViewSubtitle(leadingReference: title.leadingAnchor, topReference: title.bottomAnchor)
    }()
    
    var model: CollectionViewCellModel? {
        didSet {
            self.title.text = model?.title ?? "No title provided"
            self.date.text = model?.prettyDate ?? "No date"
            self.imageView.image = UIImage(named: "broken")
            
            guard let url = model?.imageURL else { return }
            
            if let image = imageCache[url.absoluteString] {
                // Image already exists in cache
                self.imageView.image = image
            } else {
                // Download image over network
                self.model!.homeViewModel.downloadFile(url: url) { (data, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        guard let data = data else { return }
                        let image = UIImage(data: data)
                        
                        // Cache the image
                        imageCache[url.absoluteString] = image
                        
                        DispatchQueue.main.async {
                            self.imageView.image = image
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

class TallerTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = UI.tabBarHeight
        return sizeThatFits
    }
}
