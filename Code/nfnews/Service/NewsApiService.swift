//
//  NewsApiService.swift
//  nfnews
//
//  Created by Work on 2/7/21.
//

import Foundation

enum APIError: Error {
    case decodeError(String)
    case fileError(String)
    case apiGeneratedError(String)
}

/// Avoiding traditional Singleton pattern so code isn't TOO loosely coupled
protocol APIServiceable {
    func fetchTopHeadlines(_ completion: @escaping (Result<NewsApiResponse, APIError>) -> Void )
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
