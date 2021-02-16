//
//  HomeCoordinatorDelegate.swift
//  scratch
//
//  Created by Work on 2/15/21.
//
import Foundation

protocol HomeViewModelType {
    var viewDelegate: HomeViewModelViewDelegate? { get set }

    // Data Source

    func numberOfRowsInSection(section: Int) -> Int

    func numberOfSections() -> Int
    
    func heightForRowAt(indexPath: IndexPath) -> Double
    
    func viewDataForCell(at indexPath: IndexPath) -> HomeTableViewCellViewDataType?

    func didSelectArticle(article: HomeCollectionViewCellViewDataType)
    
    // Events
    func start()

    func fetchHeadlines()
    
    func downloadFile(url: URL, completion: @escaping(Data?) -> Void)

}

protocol HomeViewModelCoordinatorDelegate {
    func didSelectArticle(article: HomeCollectionViewCellViewDataType)
}

protocol HomeViewModelViewDelegate {

    func updateScreen()
    
    func updateState(_ state: HomeControllerState)

}
