//
//  NetworkManager.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 07.07.2022.
//

import Foundation

enum NetworkResponse: String, Error {
    case success
    case authError = "auth error"
    case badRequest = "bad request"
    case failed = "network request failed"
    case noData = "response returned with no data to decode"
    case unableToDecode = "could not decode the response"
}

class NetworkManager {
    private let router: NetworkRouter<NewsAPI> = .init()
    
    func getNews(route: NewsAPI, completionHandler: @escaping ((Result<NewsModel, Error>) -> Void)) {
        router.request(route) { data, response, error in
            guard error != nil else {
                completionHandler(.failure(error!))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completionHandler(.failure(NetworkResponse.noData))
                        return
                    }
                    do {
                        let data = try JSONDecoder().decode(NewsModel.self, from: responseData)
                        completionHandler(.success(data))
                    } catch {
                        completionHandler(.failure(NetworkResponse.unableToDecode))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String, Error> {
        switch response.statusCode {
        case 200...299: return .success(NetworkResponse.success.rawValue)
        case 401...500: return .failure(NetworkResponse.authError)
        case 501...599: return .failure(NetworkResponse.badRequest)
        default: return .failure(NetworkResponse.failed)
        }
    }
}
