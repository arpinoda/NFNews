//
//  NFNData.swift
//  nfnews
//
//  Created by Work on 2/7/21.
//

import Foundation

struct NewsApiResponse: Codable, Equatable {
    let status: String
    let totalResults: Int
    let articles: [NewsApiArticle]?
    
    // Populated when error occurs
    let code: String?
    let message: String?
    
    static func == (lhs: NewsApiResponse, rhs: NewsApiResponse) -> Bool {
        return lhs.status == rhs.status && lhs.totalResults == rhs.totalResults
    }
    
    
}
