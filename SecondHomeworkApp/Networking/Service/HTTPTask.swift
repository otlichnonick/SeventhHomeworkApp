//
//  HTTPTask.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 05.07.2022.
//

import Foundation

enum HTTPTask {
    case request
    case requestWithParameters(bodyParameters: Parameters?, urlParameters: Parameters?)
}

typealias HTTPHeaders = [String: String]
