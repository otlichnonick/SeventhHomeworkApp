//
//  Enums.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 08.07.2022.
//

import Foundation

enum LoadState {
    case notRequest
    case loading
    case success
    case error
}

enum NewsType {
    case all, top
    
    var title: String {
        switch self {
        case .all:
            return "Все новости"
        case .top:
            return "Главное"
        }
    }
}
