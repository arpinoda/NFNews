//
//  HomeDetailViewModel.swift
//  scratch
//
//  Created by Work on 2/15/21.
//

import Foundation

class HomeDetailViewModel {
    
    // MARK: - Coordinator delegate
    var coordinatorDelegate: HomeDetailViewModelCoordinatorDelegate?
    
    var article: HomeCollectionViewCellViewDataType!
    
    init(viewData: HomeCollectionViewCellViewDataType) {
        self.article = viewData
    }
}

extension HomeDetailViewModel: HomeDetailViewModelType {
    
    func didCloseArticle() {
        coordinatorDelegate?.didCloseArticle()
    }
    
}
