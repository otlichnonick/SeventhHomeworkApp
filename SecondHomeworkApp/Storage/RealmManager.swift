//
//  RealmManager.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 09.11.2022.
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    private var localRealm: Realm?
    @Published var allNews: [AllNewsRealmModel] = .init()
    @Published var topNews: [TopNewsRealmModel] = .init()
    
    init() {
        openRealm()
        getAllNews()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1) { migration, oldSchemaVersion in
                if oldSchemaVersion>1 {
                    
                }
            }
            
            Realm.Configuration.defaultConfiguration = config
            
            localRealm = try Realm()
        } catch {
            print("Error opening Realm", error)
        }
    }
    
    func addAllNews(_ news: AllNewsRealmModel) {
        guard allNews.contains(where: { $0.uuid == news.uuid }) else {
            print("already contain news with uuid: \(news.uuid)")
            return
        }
        
        if let localRealm = localRealm {
            do {
                try localRealm.write({
                    localRealm.add(news)
                    print("Added new model to Realm")
                })
            } catch {
                print("Error adding to Realm", error)
            }
        }
    }
    
    func getAllNews() {
        if let localRealm = localRealm {
            let news = localRealm.objects(AllNewsRealmModel.self)
            news.forEach { allNews.append($0) }
        }
    }
    
    func deleteNews(with id: String) {
        if let localRealm = localRealm {
            let allNewsArray = localRealm.objects(AllNewsRealmModel.self)
            let news = allNewsArray.filter({ $0.uuid == id })
            guard !news.isEmpty else { return }
            
            do {
                try localRealm.write {
                    localRealm.delete(news)
                    allNews = []
                    getAllNews()
                    print("News deleted from Realm")
                }
            } catch {
                print("Error deleting news", error)
            }
        }
    }
}
