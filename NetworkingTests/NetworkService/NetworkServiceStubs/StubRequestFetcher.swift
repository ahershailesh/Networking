//
//  StubRequestFetcher.swift
//  NewsAppTests
//
//  Created by Shailesh Aher on 22/09/20.
//  Copyright © 2020 Shailesh Aher. All rights reserved.
//

import Foundation
@testable import Networking

class StubRequestFetcher: RequestFetcher {
    let data: Data?
    let response: URLResponse?
    let error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        DispatchQueue.main.async {
            completionHandler(self.data, self.response, self.error)
        }
        return URLSession.shared.dataTask(with: URL(string: "www.google.com")!)
    }
}
