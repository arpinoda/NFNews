//
//  HomeTableViewViewData.swift
//  nfnews
//
//  Created by Work on 2/16/21.
//

import Foundation

struct HomeCollectionViewCellViewData: HomeCollectionViewCellViewDataType {
    
    var title: String
    
    var imageURL: URL?
    
    var prettyDate: String
    
    var sourceURL: URL
    
    init(bareModel: NewsApiArticle) {
        
        self.title = bareModel.title ?? "Untitled"
        
        self.imageURL = bareModel.urlToImage != nil ? URL(string: bareModel.urlToImage!) : nil
        
        self.sourceURL = bareModel.url != nil ? URL(string: bareModel.url!)! : URL(string: "https://www.google.com")!
        
        self.prettyDate = "n/a"
        
        if let publishedAtString = bareModel.publishedAt, let publishedAtDate = DateFormatter.iso8601.date(from: publishedAtString) {
            self.prettyDate = Date.prettyTimestamp(since: publishedAtDate)
        }
        
    }
    
}
