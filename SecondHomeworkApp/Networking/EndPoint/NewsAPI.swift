//
//  NewsAPIService.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 05.07.2022.
//

import Foundation
import Combine

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

enum NewsAPI {
    case all(page: Int, categories: [String])
    case top(page: Int, categories: [String])
    case newsByUuid(uuid: String)
}

extension NewsAPI: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.thenewsapi.com/v1/news/") else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .all:
            return "all"
        case .top:
            return "top"
        case .newsByUuid(let uuid):
            return "uuid/\(uuid)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .all(let page, let categories):
            return .requestWithParameters(bodyParameters: nil, urlParameters: ["api_token": Constants.apiKey, "page": page, "categories": categories])
        case .top(let page, let categories):
            return .requestWithParameters(bodyParameters: nil, urlParameters: ["api_token": Constants.apiKey, "page": page, "categories": categories])
        case .newsByUuid:
            return .requestWithParameters(bodyParameters: nil, urlParameters: ["api_token": Constants.apiKey])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
