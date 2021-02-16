//
//  HomeTableViewCellViewDataType.swift
//  nfnews
//
//  Created by Work on 2/16/21.
//

import Foundation

protocol HomeTableViewCellViewDataType {
    
    var title: String { get }

    var items: [HomeCollectionViewCellViewData] { get }

    var indexPathSection: Int { get }
    
}
