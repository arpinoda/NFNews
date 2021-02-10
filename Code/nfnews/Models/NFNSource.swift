//
//  NFNSource.swift
//  nfnews
//
//  Created by Work on 2/9/21.
//

import Foundation

struct NFNSource {
    let id: String?
    let name: String?
    var indexPathSection: Int
    var articles: [NewsApiArticle]?
    var tableViewCellModel: TableViewCellModel?
}
