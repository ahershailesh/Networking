//
//  NetworkService.swift
//  NewsApp
//
//  Created by Shailesh Aher on 22/09/20.
//  Copyright © 2020 Shailesh Aher. All rights reserved.
//

import Foundation

public protocol NetworkRequestExecutable {
    func execute<T: Decodable>(request: URLRequest, completionBlock: @escaping (Result<T, Error>) -> Void)
    func execute(request: URLRequest, completionBlock: @escaping (Data?, URLResponse?, Error?) -> Void)
}

public protocol RequestFetcher {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: RequestFetcher { }

public protocol Decoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: Decoder {  }

public class NetworkRequestExecuter: NetworkRequestExecutable {
    private let requestFetcher: RequestFetcher
    private let decoder: Decoder
    
    public init(requestFetcher: RequestFetcher = URLSession.shared,
         decoder: Decoder = JSONDecoder()) {
        self.requestFetcher = requestFetcher
        self.decoder = decoder
    }

    public func execute<T: Decodable>(request: URLRequest, completionBlock: @escaping (Result<T, Error>) -> Void) {
        let task = requestFetcher.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let data = data {
                do {
                    let dataObject = try self.decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completionBlock(.success(dataObject))
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        completionBlock(.failure(error))
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completionBlock(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func execute(request: URLRequest, completionBlock: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = requestFetcher.dataTask(with: request, completionHandler: completionBlock)
        task.resume()
    }
}
