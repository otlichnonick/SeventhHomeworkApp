//
//  APICall.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 07.07.2022.
//

import Foundation

protocol APICall {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
}

extension APICall {
    func urlRequest(baseUrl: String) throws -> URLRequest {
        guard let url = URL(string: baseUrl + path) else {
            throw ErrorHandler.notValidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = nil
        NetworkLogger.log(request: request)
        return request
    }
    
    func urlRequest<BodyData: Codable>(baseURL: String, bodyData: BodyData) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw ErrorHandler.notValidURL
        }
        
        guard let body = try? JSONEncoder().encode(bodyData) else {
            debugPrint("Error: Trying to convert model to JSON data")
            throw ErrorHandler.notValidBody
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        NetworkLogger.log(request: request)
        return request
    }
}

public enum HTTPMethod: String {
    case GET
    case POST
    case PATCH
    case PUT
    case DELETE
}

public typealias HTTPHeaders = [String: String]
public typealias HTTPQuery = [String: String]

public extension JSONDecoder {
    static let snakeCaseConverting: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}

public struct URLBuilder {
    public static func buildQuery(path: String, queryParams: [String: String]) -> String {
        var urlComponents = URLComponents()
        urlComponents.path = path
        urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0, value: $1) }
        guard let urlString = urlComponents.url?.absoluteString else { return "" }
        return urlString
    }
}
