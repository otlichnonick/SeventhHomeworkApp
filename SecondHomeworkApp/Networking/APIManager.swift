//
//  APIManager.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 07.07.2022.
//

import Foundation
import Combine

protocol APIManagerProtocol {
    var baseURL: String { get }
}

private extension APIManagerProtocol {
    func fetch<Output: Codable>(endpoint: APICall, decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Output, Error> {
          do {
              let request = try endpoint.urlRequest(baseUrl: baseURL)
              return URLSession.shared.dataTaskPublisher(for: request)
                  .tryMap { result -> Output in
                      let httpResponse = result.response as? HTTPURLResponse
                      NetworkLogger.log(response: httpResponse, data: result.data)
                      
                      if httpResponse?.statusCode == 204 {
                          throw ErrorHandler.noContent
                      }
          
                      return try ErrorHandler.checkDecodingErrors(decoder: decoder, model: Output.self, with: result.data)
                  }
                  .eraseToAnyPublisher()
          } catch {
              return AnyPublisher(
                  Fail<Output, Error>(error: ErrorHandler.notValidURL)
              )
          }
      }
      
      func fetch<Input: Codable, Output: Codable>(endpoint: APICall, params: Input? = nil, decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Output, Error> {
          do {
              let request = try endpoint.urlRequest(baseURL: baseURL, bodyData: params)
              return URLSession.shared.dataTaskPublisher(for: request)
                  .tryMap { result -> Output in
                      let httpResponse = result.response as? HTTPURLResponse
                      NetworkLogger.log(response: httpResponse, data: result.data)
                      
                      if httpResponse?.statusCode == 204 {
                          throw ErrorHandler.noContent
                      }
                      
                      return try ErrorHandler.checkDecodingErrors(decoder: decoder, model: Output.self, with: result.data)
                  }
                  .eraseToAnyPublisher()
          } catch {
              return AnyPublisher(
                  Fail<Output, Error>(error: ErrorHandler.notValidURL)
              )
          }
      }
  }

struct APIManager: APIManagerProtocol {
    var baseURL: String = Constants.baseUrl
    
    func getAllNews(queryParams: [String: String]) -> AnyPublisher<NewsModel, Error> {
        return fetch(endpoint: API.getAllNews(queryParams))
    }
    
    func getTopNews(queryParams: [String: String]) -> AnyPublisher<NewsModel, Error> {
        return fetch(endpoint: API.getTopNews(queryParams))
    }
    
    func getNews(with uuid: String, and queryParams: [String: String]) -> AnyPublisher<DataModel, Error> {
        return fetch(endpoint: API.getDetailNews(uuid, queryParams))
    }
}

extension APIManager {
    enum API {
        case getAllNews([String: String])
        case getTopNews([String: String])
        case getDetailNews(String, [String: String])
    }
}

extension APIManager.API: APICall {
    var path: String {
        switch self {
        case .getAllNews(let queryParams):
            return URLBuilder.buildQuery(path: "all", queryParams: queryParams)
        case .getTopNews(let queryParams):
            return URLBuilder.buildQuery(path: "top", queryParams: queryParams)
        case .getDetailNews(let uuid, let queryParams):
            return URLBuilder.buildQuery(path: "uuid/\(uuid)", queryParams: queryParams)
        }
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    
}
