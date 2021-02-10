//
//  NewsApiService.swift
//  nfnews
//
//  Created by Work on 2/7/21.
//

import Foundation

enum APIError: Error, Equatable {
    case apiGeneratedError
    case decodeError
    case fileError
    case requestFailed
    case statusCodeInvalid
}

/// Avoiding traditional Singleton pattern so code isn't TOO loosely coupled
protocol APIServiceable {
    func fetchTopHeadlines(_ completion: @escaping (Result<NewsApiResponse, APIError>) -> Void )
}

/// NewsApi.org official API
class RemoteAPIService: APIServiceable {
    private lazy var NEWS_API_KEY: String = {
        return ProcessInfo.processInfo.environment["NEWS_API_KEY"] ?? ""
    }()
    
    private var session: URLSession
    
    private lazy var headers: [String:String] = {
        return [ "authorization" : self.NEWS_API_KEY ]
    }()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchTopHeadlines(_ completion: @escaping (Result<NewsApiResponse, APIError>) -> Void) {
       
        // NewsApi.org news-sources to fetch - https://newsapi.org/docs/endpoints/sources
        let newsSourcesCSV = "buzzfeed,engadget,espn,bbc-news,techcrunch,business-insider,bloomberg"
        let urlString = "https://newsapi.org/v2/top-headlines?sources=\(newsSourcesCSV)"
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        session.dataTask(with: request) { (data, response, error) in
            
            // Ensure we have a response
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }

            // Does statusCode reside within expected range 200...299
            if !response.isResponseOK() {
                completion(.failure(.statusCodeInvalid))
                return
            }

            // Is there an error
            if let error = error {
                let message = error.localizedDescription
                print(message)
                completion(.failure(.apiGeneratedError))
                return
            }

            // Examine the data
            guard let data = data else {
                completion(.failure(.decodeError))
                return
            }

            // Parse data into NFNResponse model object
            do {
                let decodedData = try JSONDecoder().decode(NewsApiResponse.self, from: data)

                if decodedData.status == "error" {
                    completion(
                        .failure(.apiGeneratedError)
                    )
                } else {
                    completion(
                        .success(decodedData)
                    )
                }
            } catch {
                completion(
                    .failure(.decodeError)
                )
            }
            
        }.resume()
    }
}

/// Simulates remote API by returning data from local JSON file
class LocalAPIService: APIServiceable {
    fileprivate var localFileName = "APIResponse"
    fileprivate let NETWORK_LATENCY_SECONDS = 2.0
    
    func fetchTopHeadlines(_ completion: @escaping (Result<NewsApiResponse, APIError>) -> Void) {
        let jsonData = Helpers.readLocalFile(forName: localFileName)
        
        // Mimic network latency by delaying 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + NETWORK_LATENCY_SECONDS) {
            // Ensure the file's contents are not nil
            guard let data = jsonData else {
                completion(
                    .failure(.fileError)
                )
                return
            }
            
            // Parse data into NFNResponse model object
            do {
                let decodedData = try JSONDecoder().decode(NewsApiResponse.self, from: data)
                
                if decodedData.status == "error" {
                    completion(
                        .failure(.apiGeneratedError)
                    )
                } else {
                    completion(
                        .success(decodedData)
                    )
                }
            } catch {
                completion(
                    .failure(.decodeError)
                )
            }
        }
    }
}
