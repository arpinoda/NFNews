//
//  HomeViewModel.swift
//  nfnews
//
//  Created by Work on 2/7/21.
//

import Foundation

class HomeViewModel {
    fileprivate var nfnData: NewsApiResponse?
    fileprivate var apiClient: APIServiceable
    
    // Closure-based callbacks using typealias
    typealias OnLoading = (() -> Void)
    typealias OnError = ((String) -> Void)
    typealias OnSuccess = (() -> Void)
    typealias OnArticleTapped = ((CollectionViewCellModel) -> Void)
    
    var onLoading: OnLoading
    var onError: OnError
    var onSuccess: OnSuccess
    var onArticleTapped: OnArticleTapped
    
    // Transformed models for the view
    var tableViewCellModels = Dictionary<String, TableViewCellModel>()
    
    init(apiClient: APIServiceable, onLoading: @escaping OnLoading, onError: @escaping OnError, onSuccess: @escaping OnSuccess, onArticleTapped: @escaping OnArticleTapped) {
        self.apiClient = apiClient
        self.onLoading = onLoading
        self.onError = onError
        self.onSuccess = onSuccess
        self.onArticleTapped = onArticleTapped
    }
    
    func fetchHeadlines() {
        self.onLoading()
        self.apiClient.fetchTopHeadlines { (result) in
            switch result {
            case .success(let data):
                self.nfnData = data
                self.transformResponse(data)
                self.onSuccess()
                break
            case .failure(let error):
                print(error)
                self.onError(error.localizedDescription)
                break
            }
        }
    }
    
    func downloadFile(url: URL, completion: @escaping(Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            completion(data, error)
        }.resume()
    }
    
    // Transform Api response into models compatible with tableView and collectionViews
    // Each news source is represented by a single TableViewCell, existing in 1 row within 1 unique section.
    // Each article represents a CollectionViewCell within the parent TableViewCell
    private func transformResponse(_ data: NewsApiResponse) {
        tableViewCellModels.removeAll()
        
        // Since Dictionary is unordered, this values makes it easy to lookup appropriate model during cell rendering
        var indexPathSection = 0
        
        data.articles?.forEach({ (article) in
            let sourceId = article.source.id ?? UUID().uuidString
            let collectionViewCellModel = createModel(forCollectionViewCell: article)
            
            // If news source doesn't exist in local collection
            if !(tableViewCellModels.keys.contains(sourceId)) {
                
                // Create it & insert into local collection
                tableViewCellModels[sourceId] = TableViewCellModel(
                    title: article.source.name ?? "Untitled",
                    items: [CollectionViewCellModel](),
                    homeViewModel: self,
                    indexPathSection: indexPathSection
                )
                
                indexPathSection += 1
            }
            
            // Append this article to the source
            tableViewCellModels[sourceId]!.items.append(collectionViewCellModel)
        })
    }
    
    // Creates a CollectionViewCellModel from an APIArticle
    private func createModel(forCollectionViewCell newsApiArticle: NewsApiArticle) -> CollectionViewCellModel {
        let title = newsApiArticle.title ?? "Untitled"
        let imageURL = newsApiArticle.urlToImage != nil ? URL(string: newsApiArticle.urlToImage!) : nil
        let sourceURL = newsApiArticle.url != nil ? URL(string: newsApiArticle.url!)! : URL(string: "https://www.google.com")!
        var prettyDate = "n/a"
        
        if let publishedAtString = newsApiArticle.publishedAt, let publishedAtDate = DateFormatter.iso8601.date(from: publishedAtString) {
            prettyDate = Date.prettyTimestamp(since: publishedAtDate)
        }
        
        return CollectionViewCellModel(
            title: title,
            imageURL: imageURL,
            prettyDate: prettyDate,
            sourceURL: sourceURL,
            homeViewModel: self
        )
    }
}

// MARK: - TableView Datasource & Delegate
extension HomeViewModel {
    func numberOfRowsInSection(section: Int) -> Int {
        // Each section corresponds to a news source, & contains only 1 row.
        // This row renders a collectionView, whose cell count equals the # of articles
        return 1
    }
    
    func numberOfSections() -> Int {
        return tableViewCellModels.count
    }
    
    func heightForRowAt(indexPath: IndexPath) -> Double {
        return Double(TableViewCell.cellHeight)
    }
    
    func modelForCell(at indexPath: IndexPath) -> TableViewCellModel? {
        guard let modelQuery = tableViewCellModels.first(where: { $0.value.indexPathSection == indexPath.section }) else {
            return nil
        }
        return modelQuery.value
    }
}
