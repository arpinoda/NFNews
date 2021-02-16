//
//  HomeDetailViewModelType.swift
//  nfnews
//
//  Created by Work on 2/16/21.
//

import Foundation

protocol HomeDetailViewModelType {
    
    // Events
    func didCloseArticle()

}

protocol HomeDetailViewModelCoordinatorDelegate {
    func didCloseArticle()
}
