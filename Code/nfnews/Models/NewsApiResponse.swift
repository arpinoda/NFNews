//
//  NFNData.swift
//  nfnews
//
//  Created by Work on 2/7/21.
//

import Foundation

struct NewsApiResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsApiArticle]?
    
    // Populated when error occurs
    let code: String?
    let message: String?
}
