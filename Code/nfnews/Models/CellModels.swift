//
//  TableViewCellModel.swift
//  nfnews
//
//  Created by Work on 2/9/21.
//

import Foundation

struct TableViewCellModel {
    var title: String
    var items: [CollectionViewCellModel]
    var homeViewModel: HomeViewModel
}

struct CollectionViewCellModel {
    var title: String
    var imageURL: URL?
    var prettyDate: String
    var sourceURL: URL
    var homeViewModel: HomeViewModel
}
