//
//  BaseNetwork.swift
//  WeatherApp
//
//  Created by Biju Varghese on 5/24/23.
//

import Foundation

enum HTTPMethod: String {
    case CONNECT, DELETE, GET, HEAD, OPTIONS, POST, PUT, TRACE
    
    func name() -> String {
        switch self {
        default:
            return self.rawValue
        }
    }
}
protocol URLRequestMaker {
    func getURLRequest(url: URL, httpMethod: HTTPMethod, httpBody: Data?) -> URLRequest
}

extension URLRequestMaker {
    func getURLRequest(url: URL, httpMethod: HTTPMethod = .GET, httpBody: Data? = nil) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.name()
        urlRequest.httpBody = httpBody
        return urlRequest
    }
}

public class ServiceInvoker<Response: Codable>: URLRequestMaker {
    
    var urlString: String = ""
    var completion: ((Result<Response, BaseNetworkingError>) -> Void)?
    
    public init(urlString: String) {
        self.urlString = urlString
    }
    
    public func getData(completion: @escaping ((Result<Response, BaseNetworkingError>) -> Void)) {
        self.completion = completion
        guard let url = URL(string: urlString) else {
            completion(.failure(BaseNetworkingError.urlCreationFailure))
            return
        }
        let urlRequest = getURLRequest(url: url)
       
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            self?.parseData(data: data, response: response, error: error)
        }
        task.resume()
    }
    
    func parseData(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            // Send error
            parseError(error: error)
        } else if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
            // Parse the data
            if let data = data {
                do {
                    let parsedJson = try JSONDecoder().decode(Response.self, from: data)
                    completion?(.success(parsedJson))
                } catch {
                    completion?(.failure(BaseNetworkingError.errorParsingJson))
                }
            } else {
                completion?(.failure(BaseNetworkingError.emptyData))
            }
        } else {
            completion?(.failure(BaseNetworkingError.unknownError))
        }
    }
    
    func parseError(error: Error) {
        // mapping all errors to emptydata error
        completion?(.failure(BaseNetworkingError.emptyData))
    }
}


public enum BaseNetworkingError: Error {
    case emptyURL
    case urlCreationFailure
    case urlRequestCreationFailure
    case errorParsingJson
    case emptyData
    case unknownError
}
