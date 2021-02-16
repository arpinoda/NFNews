//
//  HomeTableViewCell.swift
//  nfnews
//
//  Created by Work on 2/15/21.
//

import UIKit

fileprivate struct Lang {
    static let untitledCategoryTitle = "Untitled"
}

class HomeTableViewCell: UITableViewCell {
    static var cellHeight:CGFloat = UI.screenHeight / 3.3
    static var lineSpacingMultiplier: CGFloat = HomeCollectionViewImageView.sizeMultiplier * 0.76
    
    private var borderDrawn = false
    var borderHidden = false
    @objc dynamic var borderColor: UIColor?
    
    var viewData: HomeTableViewCellViewDataType? {
        didSet {
            self.groupTitle.text = viewData?.title ?? Lang.untitledCategoryTitle
            self.groupTitle.sizeToFit()
            self.collectionView.reloadData()
        }
    }
    
    var viewModel: HomeViewModelType?

    lazy var handleLabel = HomeTableViewDragHandle()
    
    lazy var padding: UIEdgeInsets = {
        let pt = 0.18 * HomeTableViewCell.cellHeight
        let pl = 0.5 * HomeTableView.leftTrackWidth
        let pb = 0.4 * HomeTableViewCell.cellHeight
        var i = UIEdgeInsets(top: pt, left: pl, bottom: pb, right: 0)
        
        return i
    }()
    
    lazy var groupTitle: AppTableViewTitle = {
        // Re-position and re-size label to accommodate rotation
        let offset = (HomeTableView.leftTrackWidth / 2) - (HomeTableViewCell.cellHeight / 2)
        let leading = offset + padding.bottom / 2
        let top = -offset
        let topLeft = CGPoint(x: leading, y: top)
        
        let width = HomeTableViewCell.cellHeight - padding.bottom
        let height = HomeTableView.leftTrackWidth
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
        cv.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.reuseIdentifier)
        cv.decelerationRate = UIScrollView.DecelerationRate.fast
        return cv
    }()
        
    lazy var flowLayout: RollingFadeLayout = {
        let fl = RollingFadeLayout(scrollDirection: .vertical)
        return fl
    }()
    
    lazy var border: CALayer = {
        let border = CALayer()
        if let borderColor = self.borderColor {
            border.backgroundColor = borderColor.withAlphaComponent(0.15).cgColor
        }
        let width = 1
        border.frame = CGRect(x: Int(HomeTableView.leftTrackWidth + 1), y: 0, width: Int(self.frame.width), height: width)
        
        return border
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
        self.border.isHidden = borderHidden
        
        if !borderDrawn {
            borderDrawn = true
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
        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: HomeTableView.leftTrackWidth).isActive = true
        collectionView.contentInset = UIEdgeInsets(top: padding.top, left: 0, bottom: 0, right: 0)
    }
}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewData?.items.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let viewData = viewData else { return }
        
        let article = viewData.items[indexPath.row]
        
        if let viewModel = viewModel {
            viewModel.didSelectArticle(article: article)
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 2.5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
               layout collectionViewLayout: UICollectionViewLayout,
               insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeCollectionViewCell, let viewData = viewData?.items[indexPath.row] {
            
            if let viewModel = viewModel {
                cell.viewModel = viewModel
            }
            
            cell.viewData = viewData
            
            return cell
        }
        return UICollectionViewCell()
    }
    
}
