//
//  ViewModel.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 05.07.2022.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    @Published var selectedSegment = 0
    @Published var newsModel: NewsModel = .init()
    @Published var categories: [String] = .init()
    @Published var selectedNews: DataModel?
    
    @Published var allNewsPage: Int = 1
    @Published var allNewsList: [DataModel] = .init()
    @Published var canLoadAllNewsNextPage: Bool = true
    @Published var allNewsLoadState: LoadState = .notRequest
    
    @Published var topNewsPage: Int = 1
    @Published var topNewsList: [DataModel] = .init()
    @Published var canLoadTopNewsNextPage: Bool = true
    @Published var topNewsLoadState: LoadState = .notRequest
    
    @Published var detailNewsLoadState: LoadState = .notRequest
    
    private let presenter: BasePresenter = .init()
    private var bag = Set<AnyCancellable>()
    private let realmManager = RealmManager()
    
    var list: [DataModel] {
        selectedSegment == 0 ? allNewsList : topNewsList
    }
    
    var selectedNewsIndex: Int? {
        list.firstIndex(where: { $0.uuid == selectedNews?.uuid })
    }
    
    var nextNewsUuid: String? {
        selectedNewsIndex.map { value in
            let index = list.index(after: value)
            return list[index].uuid
        }
    }
    
    var previousNewsUuid: String? {
        guard let selectedNewsIndex = selectedNewsIndex else {
            return nil
        }
        let index = list.index(before: selectedNewsIndex)
        return list[safeIndex: index]?.uuid
    }
    
    func getNews() {
        selectedSegment == 0 ? getAllNews() : getTopNews()
    }
    
    private func getAllNews() {
        guard canLoadAllNewsNextPage, allNewsLoadState != .loading else { return }
        allNewsLoadState = .loading
        presenter.getAllNews(queryParams: ["api_token": Constants.apiKey, "page": self.allNewsPage.description, "language": "en"]) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                if response.data.isEmpty {
                    strongSelf.canLoadAllNewsNextPage = false
                }
                strongSelf.allNewsList += response.data
                strongSelf.allNewsPage += 1
                strongSelf.allNewsLoadState = .success
            case .failure(let error):
                strongSelf.allNewsLoadState = .error
                strongSelf.canLoadAllNewsNextPage = false
                debugPrint("error with all news", error)
            }
        }
    }
    
    private func getTopNews() {
        guard canLoadTopNewsNextPage, topNewsLoadState != .loading else { return }
        topNewsLoadState = .loading
        presenter.getTopNews(queryParams: ["api_token": Constants.apiKey, "page": self.topNewsPage.description, "language": "en"]) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                if response.data.isEmpty {
                    strongSelf.canLoadTopNewsNextPage = false
                }
                strongSelf.topNewsList += response.data
                strongSelf.topNewsPage += 1
                strongSelf.topNewsLoadState = .success
            case .failure(let error):
                strongSelf.topNewsLoadState = .error
                strongSelf.canLoadTopNewsNextPage = false
                debugPrint("error with all news", error)
            }
        }
    }
    
    private func addToRealm(_ model: DataModel) {
        let realmModel = AllNewsRealmModel()
        realmModel.uuid = model.uuid
        realmModel.title = model.title
        realmModel.descriptionNews = model.description
        realmModel.image_url = model.image_url
        realmManager.addAllNews(realmModel)
    }
    
    func getDetailNews(with uuid: String) {
        detailNewsLoadState = .loading
        presenter.getSelectedNews(with: uuid, and: ["api_token": Constants.apiKey]) { [weak self] result in
            guard let strongSelf = self else { return }
                switch result {
                case .success(let response):
                    strongSelf.selectedNews = response
                    strongSelf.detailNewsLoadState = .success
                case .failure(let error):
                    strongSelf.detailNewsLoadState = .error
                    debugPrint("error with detail news", error)
            }
        }
    }
}
