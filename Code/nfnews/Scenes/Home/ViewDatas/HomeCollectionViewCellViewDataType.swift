//
//  HomeCollectionViewCellViewDataType.swift
//  nfnews
//
//  Created by Work on 2/16/21.
//

import Foundation

protocol HomeCollectionViewCellViewDataType {

    var title: String { get }

    var imageURL: URL? { get }

    var prettyDate: String { get }
    
    var sourceURL: URL { get }

}
