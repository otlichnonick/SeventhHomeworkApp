//
//  NewsModel.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 05.07.2022.
//

import Foundation

struct NewsModel: Codable {
    let meta: MetaModel
    let data: [DataModel]
}

struct MetaModel: Codable {
    let found: Int
    let page: Int
}

struct DataModel: Codable {
    let uuid: String
    let title: String
    let description: String?
    let image_url: String?
}
