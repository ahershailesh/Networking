//
//  ImageCacher.swift
//  NewsApp
//
//  Created by Shailesh Aher on 26/09/20.
//  Copyright © 2020 Shailesh Aher. All rights reserved.
//

import Foundation

public protocol ResponseCacheable {
    func fetch(request: URLRequest, fromCache: Bool, completionBlock: @escaping (Result<Data, Error>) -> Void)
}

public class ResponseCacher: ResponseCacheable {
    private let executer: NetworkRequestExecutable
    private let cache = URLCache()
    
    public init(executer: NetworkRequestExecutable = NetworkRequestExecuter()) {
        self.executer = executer
    }
    
    public func fetch(request: URLRequest, fromCache: Bool = true, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        if fromCache, let response = cache.cachedResponse(for: request) {
            completionBlock(Result.success(response.data))
            return
        }
        executer.execute(request: request) { [weak self] (data, response, error) in
            if let data = data,
                let response = response  {
                self?.cache.storeCachedResponse(CachedURLResponse(response: response, data: data, userInfo: [:], storagePolicy: .allowed), for: request)
                completionBlock(Result.success(data))
            } else if let error = error {
                completionBlock(Result.failure(error))
            }
        }
    }
}
    
