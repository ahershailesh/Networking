//
//  NetworkRequestDataProvider.swift
//  NewsApp
//
//  Created by Shailesh Aher on 23/09/20.
//  Copyright © 2020 Shailesh Aher. All rights reserved.
//

import Foundation

public enum NetworkRequestType {
    case get, post(body: String), patch(body: String), delete
    
    public var method: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .patch: return "PATCH"
        case .delete: return "DELETE"
        }
    }
}

public protocol NetworkRequestDataProvider {
    var path: String { get }
    var type: NetworkRequestType  { get }
}
