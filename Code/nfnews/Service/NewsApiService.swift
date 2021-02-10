//
//  NewsApiService.swift
//  nfnews
//
//  Created by Work on 2/7/21.
//

import Foundation

enum APIError: Error {
    case apiGeneratedError(String)
    case decodeError(String)
    case fileError(String)
    case requestFailed
    case statusCodeInvalid(String)
}

/// Avoiding traditional Singleton pattern so code isn't TOO loosely coupled
protocol APIServiceable {
    func fetchTopHeadlines(_ completion: @escaping (Result<NewsApiResponse, APIError>) -> Void )
}

/// NewsApi.org official API
class RemoteAPIService: APIServiceable {
    
    func fetchTopHeadlines(_ completion: @escaping (Result<NewsApiResponse, APIError>) -> Void) {
        // Ensure api key exists within env
        guard let NEWS_API_KEY = ProcessInfo.processInfo.environment["NEWS_API_KEY"] else {
            let message = "Your NewsApi.org API Key must be set in xCode's \"Run Configuration\" environment variables."
            completion(.failure(.apiGeneratedError(message)))
            return
        }
        
        // CSV list of NewsApi.org compatible news-sources
        // https://newsapi.org/docs/endpoints/sources
        let newsSourcesCSV = "buzzfeed,engadget,espn,bbc-news,techcrunch,business-insider,bloomberg"
        
        let urlString = "https://newsapi.org/v2/top-headlines?sources=\(newsSourcesCSV)"
        let headers = [ "authorization" : NEWS_API_KEY ]
        var request = URLRequest(url: URL(string: urlString)!)
        
        request.httpMethod = "GET"
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request) { (data, response, error) in
            
            // Ensure we have a response
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }
            
            // Does statusCode reside within expected range 200...299
            if !response.isResponseOK() {
                completion(.failure(.statusCodeInvalid("Received status code \(response.statusCode)")))
                return
            }
            
            // Is there an error
            if let error = error {
                let message = error.localizedDescription
                print(message)
                completion(.failure(.apiGeneratedError(message)))
                return
            }
            
            // Examine the data
            guard let data = data else {
                completion(.failure(.decodeError("Cannot decode empty data")))
                return
            }
            
            // Parse data into NFNResponse model object
            do {
                let decodedData = try JSONDecoder().decode(NewsApiResponse.self, from: data)
                
                if decodedData.status == "error" {
                    let apiErrorMessage = decodedData.message ?? "Not provided"
                    completion(
                        .failure(.apiGeneratedError(apiErrorMessage))
                    )
                } else {
                    completion(
                        .success(decodedData)
                    )
                }
            } catch (let err) {
                completion(
                    .failure(.decodeError(err.localizedDescription))
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
                    .failure(.fileError("File does not contain data: \(self.localFileName)"))
                )
                return
            }
            
            // Parse data into NFNResponse model object
            do {
                let decodedData = try JSONDecoder().decode(NewsApiResponse.self, from: data)
                
                if decodedData.status == "error" {
                    let apiErrorMessage = decodedData.message ?? "Not provided"
                    completion(
                        .failure(.apiGeneratedError(apiErrorMessage))
                    )
                } else {
                    completion(
                        .success(decodedData)
                    )
                }
            } catch (let err) {
                completion(
                    .failure(.decodeError(err.localizedDescription))
                )
            }
        }
    }
}
