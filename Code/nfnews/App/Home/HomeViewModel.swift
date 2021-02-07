//
//  HomeViewModel.swift
//  nfnews
//
//  Created by Work on 2/7/21.
//

import Foundation

class HomeViewModel {
    fileprivate var nfnData: NFNResponse?
    fileprivate var apiClient: APIServiceable
    
    // Closure-based callbacks using typealias
    typealias OnLoading = (() -> Void)
    typealias OnError = ((String) -> Void)
    typealias OnSuccess = ((NFNResponse) -> Void)
    
    var onLoading: OnLoading
    var onError: OnError
    var onSuccess: OnSuccess
    
    init(apiClient: APIServiceable, onLoading: @escaping OnLoading, onError: @escaping OnError, onSuccess: @escaping OnSuccess) {
        self.apiClient = apiClient
        self.onLoading = onLoading
        self.onError = onError
        self.onSuccess = onSuccess
    }
    
    func fetchHeadlines() {
        self.onLoading()
        self.apiClient.fetchTopHeadlines { (result) in
            switch result {
            case .success(let data):
                self.nfnData = data
                self.onSuccess(data)
                break
            case .failure(let error):
                print(error)
                self.onError("Simplified error message for user")
                break
            }
        }
    }
}

// MARK: - Datasource methods consumed by controller
extension HomeViewModel {
    func numberOfRowsInSection(section: Int) -> Int {
        return nfnData?.articles?.count ?? 0
    }
    
    func textLabelForItem(at indexPath: IndexPath) -> String {
        guard let articles = nfnData?.articles else { return "N/A" }
        
        return articles[indexPath.row].title ?? "Untitled"
    }
}
