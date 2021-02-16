//
//  ApiClient.swift
//  scratch
//
//  Created by Work on 2/15/21.
//

import Foundation

typealias JSON = [String: Any]
typealias Headers = [String: String]

enum ApiError: Error {
    // Errors reported as part of the response (validation, insufficient permissions)
    case custom(String)
    
    // Decoding failure
    case decodingFailure(String)
    
    // Response data is empty
    case emptyData
    
    // Response object is empty
    case emptyResponse
    
    // Client does not have an internet connection
    case noInternetConnection
        
    // Errors the server fails to report as part of the response (timing outs, server crash, etc)
    case other
}

private struct Lang {
    static let emptyData = "The data returned is empty"
    static let emptyResponse = "The response is empty"
    static let noInternetConnection = "No Internet connection"
    static let other = "Something went wrong"
    static func cancelingTask(id: Int) -> String {
        return "Canceling task \(id)"
    }
}

// Make our errors more description and easy to analyze
extension ApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .custom(let message):
            return message
        case .decodingFailure(let message):
            return message
        case .emptyData:
            return Lang.emptyData
        case .emptyResponse:
            return Lang.emptyResponse
        case .noInternetConnection:
            return Lang.noInternetConnection
        case .other:
            return Lang.other
        }
    }
}

// For custom errors, transform server JSON data into an error object
extension ApiError {
    init(json: JSON) {
        if let message =  json["message"] as? String {
            self = .custom(message)
        } else {
            self = .other
        }
    }
}

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

final class ApiClient {
    private var baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func load<T:Decodable>(path: String, method: RequestMethod, params: JSON, headers: Headers? = nil, completion: @escaping (Result<T, ApiError>) -> ()) -> URLSessionDataTask? {
        
        // Checking internet connection availability
        if !Reachability.isConnectedToNetwork() {
            completion(.failure(ApiError.noInternetConnection))
            return nil
        }
        
        // Creating the URLRequest object
        let request = URLRequest(baseUrl: baseUrl, path: path, method: method, params: params, headers: headers)

        // Sending request to the server.
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Ensure we have a response
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.emptyResponse))
                return
            }
            
            // Is there a server error
            if let error = error {
                let message = error.localizedDescription
                print(message)
                completion(.failure(.custom(message)))
                return
            }
            
            // Try to parse data
            var object: T
            
            if let data = data {
                do {
                    object = try JSONDecoder().decode(T.self, from: data)
                } catch (let err) {
                    // We have received a different object type from the API
                    
                    // Does the accepted range 200...299 contain our status code?
                    if !(200...299).contains(response.statusCode) {
                        let apiObject = try? JSONSerialization.jsonObject(with: data, options: [])
                        let error = (apiObject as? JSON).flatMap(ApiError.init) ?? ApiError.other
                        completion(.failure(error))
                        return
                    }
                    
                    // Cannot decode response
                    completion(.failure(.decodingFailure(err.localizedDescription)))
                    return
                }
            } else {
                completion(.failure(.emptyData))
                return
            }
            
            completion(.success(object))
            return
        }
        
        return task
    }

    func cancelPendingTasks() {
        URLSession.shared.getAllTasks { (tasks) in
            tasks.forEach {
                print(Lang.cancelingTask(id: $0.taskIdentifier))
                $0.cancel()
            }
        }
    }
}

extension URL {
    init(baseUrl: String, path: String, params: JSON, method: RequestMethod) {
        var components = URLComponents(string: baseUrl)!
        components.path += path
        
        switch method {
        case .get, .delete:
            components.queryItems = params.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        default:
            break
        }
        
        self = components.url!
    }
}

extension URLRequest {
    init(baseUrl: String, path: String, method: RequestMethod, params: JSON, headers: Headers? = nil) {
        let url = URL(baseUrl: baseUrl, path: path, params: params, method: method)
        self.init(url: url)
        
        httpMethod = method.rawValue
        setValue("application/json", forHTTPHeaderField: "Accept")
        setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Custom headers, i.e. Bearer token or Authentication token
        if let headers = headers {
            headers.forEach { addValue($0.value, forHTTPHeaderField: $0.key) }
        }
        
        switch method {
        case .post, .put:
            httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        default:
            break
        }
    }
}
