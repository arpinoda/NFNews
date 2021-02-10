//
//  RemoteAPIServiceTests.swift
//  nfnewsTests
//
//  Created by Work on 2/10/21.
//

// Import our app
@testable import nfnews
import XCTest

class RemoteAPIServiceTests: XCTestCase {

    var service: RemoteAPIService!
    var session: URLSessionMock!
    
    override func setUp() {
        super.setUp()
        
        self.session = URLSessionMock(config: .default)
        self.service = RemoteAPIService(session: self.session)
    }
    
    override func tearDown() {
        super.tearDown()
        session = nil
        service = nil
    }

    func test_url_host_and_pathname() {
        service.fetchTopHeadlines { (result) in  }
        
        XCTAssertEqual(session.cachedUrl?.host, "newsapi.org")
        XCTAssertEqual(session.cachedUrl?.path, "/v2/top-headlines")
    }
    
    func test_api_nil_response() {
        service.fetchTopHeadlines { (result) in
            XCTAssertEqual(result, .failure(APIError.requestFailed))
        }
    }
    
    func test_api_invalid_status_code() {
        let response = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)
        
        session.response = response
        
        service.fetchTopHeadlines { (result) in
            XCTAssertEqual(result, .failure(APIError.statusCodeInvalid))
        }
    }
    
    func test_api_error() {
        let response = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        session.response = response
        session.error = NSError(domain: "Error", code: 3, userInfo: nil)
        
        service.fetchTopHeadlines { (result) in
            XCTAssertEqual(result, .failure(APIError.apiGeneratedError))
        }
    }
    
    func test_api_empty_data() {
        let response = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        session.response = response
        
        service.fetchTopHeadlines { (result) in
            XCTAssertEqual(result, .failure(APIError.decodeError))
        }
    }
    
    func test_api_failed_decoding_data() {
        let response = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        session.response = response
        session.data = Data([0, 1, 0, 1])
        
        service.fetchTopHeadlines { (result) in
            XCTAssertEqual(result, .failure(APIError.decodeError))
        }
    }
    
    func test_api_status_error() {
        let response = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        session.response = response
        let decoded = NewsApiResponse(status: "error", totalResults: 0, articles: nil, code: "error", message: nil)
        
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(decoded)
        
        session.data = encoded
        
        service.fetchTopHeadlines { (result) in
            XCTAssertEqual(result, .failure(APIError.apiGeneratedError))
        }
    }
    
    func test_api_status_ok() {
        let response = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        session.response = response
        let decoded = NewsApiResponse(status: "ok", totalResults: 0, articles: nil, code: "error", message: nil)
        
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(decoded)
        
        session.data = encoded
        
        service.fetchTopHeadlines { (result) in
            XCTAssertEqual(result, .success(decoded))
        }
    }
}


// Used to cache the URL when the URLSession invokes dataTask(with:..) by adding a stored property cachedUrl
class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    // Properties that enable us to set exactly what data or error
    // we want our mocked URLSession to return for any request.
    var data: Data?
    var error: Error?
    var response: HTTPURLResponse?
    var cachedUrl: URL?

    init(config: URLSessionConfiguration) {
        
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        let response = self.response
        
        self.cachedUrl = request.url
        
        return URLSessionDataTaskMock {
            completionHandler(data, response, error)
        }
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    private let completion: () -> Void

    init(completion: @escaping () -> Void) {
        self.completion = completion
    }

    override func resume() {
        completion()
    }
}
