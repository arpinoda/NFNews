//
//  NewsApiService.swift
//  scratch
//
//  Created by Work on 2/15/21.
//

import Foundation

fileprivate struct Lang {
    static let noApiKeyFound = "Error - You must setup your NewsApi.org Api Key as an environment variable. Please refer to README.md for more information."
}

enum Endpoints: String {
    case topHeadlines = "/top-headlines"
}

private protocol NewsService {
    var NEWS_API_KEY:String { get }
    
    func fetch(path: String, params: JSON, completion: @escaping (Result<NewsApiResponse, ApiError>) -> ()) -> URLSessionDataTask?
    
    func fetchHeadlines(completion: @escaping (Result<NewsApiResponse, ApiError>) -> ()) -> URLSessionDataTask?

    func downloadFile(url: URL, completion: @escaping(Data?, Error?) -> Void)
}

class NewsApiService {

    let apiClient: ApiClient

    // MARK: - Init
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }

}

// MARK: - API
extension NewsApiService: NewsService {
    var NEWS_API_KEY: String {
        guard let key = ProcessInfo.processInfo.environment["NEWS_API_KEY"] else {
            print(Lang.noApiKeyFound)
            return ""
        }
    
        return key
    }
    
    fileprivate func fetch(path: String, params: JSON, completion: @escaping (Result<NewsApiResponse, ApiError>) -> ()) -> URLSessionDataTask? {
        let headers = ["authorization" : self.NEWS_API_KEY]
        
        return apiClient.load(path: path, method: .get, params: params, headers: headers, completion: completion)
    }
    
    func fetchHeadlines(completion: @escaping (Result<NewsApiResponse, ApiError>) -> ()) -> URLSessionDataTask? {
        let endpoint = Endpoints.topHeadlines.rawValue
        let params = [
            "sources" : "buzzfeed, engadget, espn ,bbc-news, techcrunch, mashable, wired, vice-news, reuters, reddit-r-all",
            "pageSize" : "100"
        ]
        
        return fetch(path: endpoint, params: params, completion: completion)
    }
    
    func downloadFile(url: URL, completion: @escaping(Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            completion(data, error)
        }.resume()
    }
}
