//
//  HomeViewModel.swift
//  scratch
//
//  Created by Work on 2/15/21.
//

import Foundation

fileprivate struct Lang {
    static let fetchError = "Error fetching from service"
}

class HomeViewModel {
    // MARK: - Delegates
    var coordinatorDelegate: HomeViewModelCoordinatorDelegate?

    var viewDelegate: HomeViewModelViewDelegate?

    // MARK: - Properties
    fileprivate let service: NewsApiService

    fileprivate var bareData: NewsApiResponse?
    fileprivate var viewDataCache = Dictionary<String, HomeTableViewCellViewData>()
    
    // MARK: - Init
    init(service: NewsApiService) {
        self.service = service
    }

    func start() {
        fetchHeadlines()
    }

    // MARK: - Network
    func fetchHeadlines() {
        viewDelegate?.updateState(.loading)
        let task = service.fetchHeadlines { (response) in
            switch response {
            case .failure(let apiError):
                if let message = apiError.errorDescription {
                    self.viewDelegate?.updateState(.error(message))
                } else {
                    self.viewDelegate?.updateState(.error(Lang.fetchError))
                }
                break
            case .success(let data):
                self.transform(serviceData: data)
                self.viewDelegate?.updateState(.done)
                self.viewDelegate?.updateScreen()
                break
            }
        }
        
        task?.resume()
    }

    func downloadFile(url: URL, completion: @escaping(Data?) -> Void) {
        service.downloadFile(url: url) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let data = data else {
                    completion(nil)
                    return
                }
                completion(data)
            }
        }
    }
    
    // Transforms an article flat list to a hierarchical representation
    // Creates viewData and adds to cache
    private func transform(serviceData: NewsApiResponse) {
        viewDataCache.removeAll()
        
        // viewDataCache is unordered by default, so we populate
        // indexPathSection to maintain the tableView cell's order
        var indexPathSection = 0
        
        serviceData.articles?.forEach({ (article) in
            
            let sourceId = article.source.id ?? UUID().uuidString
            
            let cvCellViewData = HomeCollectionViewCellViewData(bareModel: article)
            
            // If news source doesn't exist in local collection
            if !(viewDataCache.keys.contains(sourceId)) {
                
                // Create it
                let tvCellViewData = HomeTableViewCellViewData(article: article, indexPathSection: indexPathSection)
                
                // Insert into local collection
                viewDataCache[sourceId] = tvCellViewData
                
                indexPathSection += 1
            }
            
            // Append this article to the source
            viewDataCache[sourceId]!.items.append(cvCellViewData)
        })
    }
}

extension HomeViewModel: HomeViewModelType {
    
    func didSelectArticle(article: HomeCollectionViewCellViewDataType) {
        coordinatorDelegate?.didSelectArticle(article: article)
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return 1
    }
    
    func numberOfSections() -> Int {
        return viewDataCache.count
    }
    
    func heightForRowAt(indexPath: IndexPath) -> Double {
        return Double(HomeTableViewCell.cellHeight)
    }
    
    func viewDataForCell(at indexPath: IndexPath) -> HomeTableViewCellViewDataType? {
        guard let modelQuery = viewDataCache.first(where: { $0.value.indexPathSection == indexPath.section }) else {
            return nil
        }
        return modelQuery.value
    }
    
}
