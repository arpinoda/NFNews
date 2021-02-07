//
//  NFNData.swift
//  nfnews
//
//  Created by Work on 2/7/21.
//

import Foundation

struct NFNResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [NFNArticle]?
    
    // Populated when error occurs
    let code: String?
    let message: String?
}
