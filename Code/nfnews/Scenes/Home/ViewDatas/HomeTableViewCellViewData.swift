//
//  HomeTableViewCellViewData.swift
//  nfnews
//
//  Created by Work on 2/16/21.
//

import Foundation

fileprivate struct Lang {
    static let untitledTitle = "Untitled"
}

struct HomeTableViewCellViewData: HomeTableViewCellViewDataType {
    
    var id: String
    
    var title: String
    
    var items: [HomeCollectionViewCellViewData]
    
    var indexPathSection: Int
    
    init(article: NewsApiArticle, indexPathSection: Int) {
        self.id = article.source.id ?? UUID().uuidString
        self.title = article.source.name ?? Lang.untitledTitle
        self.items = [HomeCollectionViewCellViewData]()
        self.indexPathSection = indexPathSection
    }
    
}
