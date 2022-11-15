//
//  NewsModel.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 05.07.2022.
//

import Foundation

struct NewsModel: Codable {
    var meta: MetaModel = .init()
    var data: [DataModel] = .init()
}

struct MetaModel: Codable {
    var found: Int = 0
    var page: Int = 0
}

struct DataModel: Codable, Equatable {
    var uuid: String?
    var title: String?
    var description: String?
    var image_url: String?
}
