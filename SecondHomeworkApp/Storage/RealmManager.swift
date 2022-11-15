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
    @Published var newsArray: [NewsRealmModel] = .init()
    
    init() {
        openRealm()
        getNews()
        print("news", newsArray)
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
    
    func addNews(_ news: NewsRealmModel) {
            guard !newsArray.contains(news) else {
                print("already contain news with uuid: \(news.uuid)")
                return
            }
        
            writeToRealm(news)
    }
    
    private func writeToRealm(_ news: NewsRealmModel) {
        if let localRealm = localRealm {
            do {
                try localRealm.write({
                    localRealm.add(news)
                    print("Added new model to Realm")
                })
            } catch {
                print("Error adding to Realm", error)
            }
        } else {
            print("no realm")
        }
    }
    
    func getNews() {
        if let localRealm = localRealm {
            let news = localRealm.objects(NewsRealmModel.self)
            news.forEach { newsArray.append($0) }
        }
    }
    
    func deleteNews(with id: String) {
        if let localRealm = localRealm {
            let allNewsArray = localRealm.objects(NewsRealmModel.self)
            let news = allNewsArray.filter({ $0.uuid == id })
            guard !news.isEmpty else { return }
            
            do {
                try localRealm.write {
                    localRealm.delete(news)
                    newsArray = []
                    getNews()
                    print("News deleted from Realm")
                }
            } catch {
                print("Error deleting news", error)
            }
        }
    }
}
