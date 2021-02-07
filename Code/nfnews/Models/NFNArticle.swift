//
//  NFNArticle.swift
//  nfnews
//
//  Created by Work on 2/7/21.
//

import Foundation

struct NFNArticle: Codable {
    let author: String?
    let title : String?
    let description : String?
    let url : String?
    let urlToImage : String?
    let publishedAt : String?
    let content : String?
    let source: NFNSource
}
