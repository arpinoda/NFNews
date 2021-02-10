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
    typealias OnArticleTapped = ((URL) -> Void)
    
    var onLoading: OnLoading
    var onError: OnError
    var onSuccess: OnSuccess
    var onArticleTapped: OnArticleTapped
    
    // Transformed models for the view
    var tableViewSections = Dictionary<String, NFNSource>()
    
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
                self.onError("Simplified error message for user")
                break
            }
        }
    }
    
    func downloadFile(url: URL, completion: @escaping(Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            completion(data, error)
        }.resume()
    }
    
    // Transform Api response so its suitable for view
    private func transformResponse(_ data: NewsApiResponse) {
        tableViewSections.removeAll()
        
        // Currently, articles are a child of source. We need to reverse this
        var indexPathSection = 0
        
        data.articles?.forEach({ (article) in
            let sourceId = article.source.id ?? ""
            
            // If source doesn't exist in local collection
            if !(tableViewSections.keys.contains(sourceId)) {
                // Add it to local collection
                tableViewSections[sourceId] = NFNSource(id: sourceId, name: article.source.name, indexPathSection: indexPathSection, articles: [NewsApiArticle]())
                
                // Then, add article to newly created section
                tableViewSections[sourceId]?.articles?.append(article)
                
                indexPathSection += 1
            } else {
                // Source already exists, let's add the article
                tableViewSections[sourceId]?.articles?.append(article)
            }
        })
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
        return tableViewSections.count
    }
    
    func heightForRowAt(indexPath: IndexPath) -> Double {
        var result: Double = 60.0
        
        if tableViewSections.count < 3 {
            result = Double(TableViewCell.cellHeight)
        } else {
            result = Double(Int((UI.screenHeight - AppTabBarController.tabBarHeight)) / tableViewSections.count)
        }

        return result
    }
    
    func modelForCell(at indexPath: IndexPath) -> TableViewCellModel? {
        guard let source = tableViewSections.first(where: { $0.value.indexPathSection == indexPath.section }), let articles = source.value.articles else {
            return nil
        }
        
        let items = articles.map { (article) -> CollectionViewCellModel in
            let imageURL = article.urlToImage != nil ? URL(string: article.urlToImage!) : nil
            let title = article.title ?? "n/a"
            
            var prettyDate = "n/a"
            
            if let publishedAtString = article.publishedAt, let publishedAtDate = DateFormatter.iso8601.date(from: publishedAtString) {
                
                prettyDate = Date.prettyTimestamp(since: publishedAtDate)
            }
            
            let sourceURL = article.url != nil ? URL(string: article.url!)! : URL(string: "https://www.google.com")!
            
            return CollectionViewCellModel(title: title, imageURL: imageURL, prettyDate: prettyDate, sourceURL: sourceURL, homeViewModel: self)
        }
        
        return TableViewCellModel(title: source.value.name ?? "Untilted", items: items, homeViewModel: self)
    }
}
