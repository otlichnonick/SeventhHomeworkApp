//
//  ViewModel.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 05.07.2022.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    @Published var newsModel: NewsModel = .init()
    @Published var categories: [String] = .init()
    @Published var selectedNews: DataModel?
    
    @Published var allNewsPage: Int = 1
    @Published var allNewsList: [DataModel] = .init()
    @Published var canLoadAllNewsNextPage: Bool = true
    @Published var allNewsLoadState: LoadState = .notRequest
    
    @Published var detailNewsLoadState: LoadState = .notRequest
    
    private let presenter: BasePresenter = .init()
    private var bag = Set<AnyCancellable>()
    private let realmManager = RealmManager()
    
    var selectedNewsIndex: Int? {
        allNewsList.firstIndex(where: { $0.uuid == selectedNews?.uuid })
    }
    
    var nextNewsUuid: String? {
        selectedNewsIndex.map { value in
            let index = allNewsList.index(after: value)
            return allNewsList[index].uuid ?? ""
        }
    }
    
    var previousNewsUuid: String? {
        guard let selectedNewsIndex = selectedNewsIndex else {
            return nil
        }
        let index = allNewsList.index(before: selectedNewsIndex)
        return allNewsList[safeIndex: index]?.uuid
    }
    
    init() {
        realmManager.$newsArray
            .sink { [weak self] realmNews in
                realmNews.forEach { realmNews in
                    let allNews = DataModel(uuid: realmNews.uuid,
                                            title: realmNews.title,
                                            description: realmNews.descriptionNews,
                                            image_url: realmNews.image_url)
                    self?.allNewsList.append(allNews)
                }
            }
            .store(in: &bag)
    }
    
    func showAllNews() {
        if allNewsList.isEmpty {
            downloadAllNews()
        }
    }
    
    func downloadAllNews() {
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
                response.data.forEach { dataModel in
                    strongSelf.addToRealm(dataModel)
                    if !strongSelf.allNewsList.contains(dataModel) {
                        strongSelf.allNewsList.append(dataModel)
                    }
                }
                strongSelf.allNewsPage += 1
                strongSelf.allNewsLoadState = .success
            case .failure(let error):
                strongSelf.allNewsLoadState = .error
                strongSelf.canLoadAllNewsNextPage = false
                debugPrint("error with all news", error)
            }
        }
    }
    
    private func addToRealm(_ model: DataModel) {
        let realmModel = NewsRealmModel()
        realmModel.uuid = model.uuid
        realmModel.title = model.title
        realmModel.descriptionNews = model.description
        realmModel.image_url = model.image_url
        realmManager.addNews(realmModel)
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
