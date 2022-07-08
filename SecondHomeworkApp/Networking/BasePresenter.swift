//
//  BasePresenter.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 08.07.2022.
//

import Foundation
import Combine

class BasePresenter {
    private var bag: Set<AnyCancellable> = .init()
    private var networkManager: APIManager = .init()
    
    func getAllNews(queryParams: [String: String], handler: @escaping (Result<NewsModel, String>) -> Void) {
        let publisher = networkManager.getAllNews(queryParams: queryParams)
        baseRequest(publisher: publisher, handler: handler)
    }
    
    func getTopNews(queryParams: [String: String], handler: @escaping (Result<NewsModel, String>) -> Void) {
        let publisher = networkManager.getTopNews(queryParams: queryParams)
        baseRequest(publisher: publisher, handler: handler)
    }
    
    func getSelectedNews(with uuid: String, and queryParams: [String: String], handler: @escaping (Result<DataModel, String>) -> Void) {
        let publisher = networkManager.getNews(with: uuid, and: queryParams)
        baseRequest(publisher: publisher, handler: handler)
    }
    
    private func baseRequest<T: Codable>(publisher: AnyPublisher<T, Error>, handler: @escaping (Result<T, String>) -> Void) {
        publisher
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .mapError { error -> Error in
                handler(.failure(error.localizedDescription))
                return error
            }
            .sink { _ in } receiveValue: { response in
                handler(.success(response))
            }
            .store(in: &bag)
    }
}

extension String: Error {}
