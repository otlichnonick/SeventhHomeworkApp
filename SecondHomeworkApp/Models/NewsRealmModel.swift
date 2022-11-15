//
//  NewsRealmModel.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 10.11.2022.
//

import Foundation
import RealmSwift

class NewsRealmModel: Object {
    @objc dynamic var uuid: String?
    @objc dynamic var title: String?
    @objc dynamic var descriptionNews: String?
    @objc dynamic var image_url: String?
}
