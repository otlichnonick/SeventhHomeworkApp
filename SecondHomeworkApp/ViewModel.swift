//
//  ViewModel.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 05.07.2022.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    @Published var selectedSegment = 0
    @Published var list: [DataModel] = .init()
    @Published var newsModel: NewsModel?
    @Published var page: Int = 1
    @Published var categories: [String] = .init()
    @Published var route: NewsAPI!
    
    private let networkManager: NetworkManager = .init()
    
    init() {
        route = .all(page: page, categories: categories)
    }
    
    func getNews() {
        networkManager.getNews(route: route) { [weak self] response in
            switch response {
            case .success(let model):
                self?.newsModel = model
                self?.list = model.data
                debugPrint("newsModel", model)
            case .failure(let error):
                debugPrint("error", error)
            }
        }
    }
}
