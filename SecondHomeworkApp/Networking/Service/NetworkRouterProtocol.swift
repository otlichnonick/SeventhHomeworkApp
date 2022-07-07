//
//  NetworkRouter.swift
//  SecondHomeworkApp
//
//  Created by Anton Agafonov on 07.07.2022.
//

import Foundation

typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

protocol NetworkRouterProtocol {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
