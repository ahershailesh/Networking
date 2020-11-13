//
//  RequestBuilder.swift
//  NewsApp
//
//  Created by Shailesh Aher on 22/09/20.
//  Copyright © 2020 Shailesh Aher. All rights reserved.
//

import Foundation

public protocol NetworkRequestConfigurator {
    func request(with dataProvider: NetworkRequestDataProvider) -> URLRequest?
}

public class NetworkRequestConstructor: NetworkRequestConfigurator {
    private let cachePolicy: URLRequest.CachePolicy
    private let timeout: TimeInterval
    private let serverURL: String
    
    public init(serverURL: String,
         cachePolicy: URLRequest.CachePolicy = .reloadRevalidatingCacheData,
         timeout: TimeInterval = 10) {
        self.serverURL = serverURL
        self.cachePolicy = cachePolicy
        self.timeout = timeout
    }
    
    public func request(with dataProvider: NetworkRequestDataProvider) -> URLRequest? {
        var component = URLComponents()
        component.path = serverURL + dataProvider.path
        if !dataProvider.query.isEmpty {
            component.queryItems = dataProvider.query.map { URLQueryItem(name: $0, value: $1) }
        }
        
        guard let url = URL(string: component.path) else { return nil }
        
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeout)
        request.httpMethod = dataProvider.type.method
        request.allHTTPHeaderFields = dataProvider.headers
        
        switch dataProvider.type {
        case .post(let body), .patch(let body):
            request.httpBody = body.data(using: .utf8)
        default: break
        }
        return request
    }
}


