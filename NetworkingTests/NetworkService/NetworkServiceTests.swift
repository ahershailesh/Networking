//
//  NewsAppTests.swift
//  NewsAppTests
//
//  Created by Shailesh Aher on 22/09/20.
//  Copyright © 2020 Shailesh Aher. All rights reserved.
//

import XCTest
@testable import Networking

class NetworkRequestExecuterTests: XCTestCase {
    
    private let testURL = URLRequest(url: URL(string: "www.google.com")!)
    
    func testFetcherData() {
        let testModal = NetworkServiceStubModal(test: "test")
        let testData = try! JSONEncoder().encode(testModal)
        
        let stubFetcher = StubRequestFetcher(data: testData, response: nil, error: nil)
        let service = NetworkRequestExecuter(requestFetcher: stubFetcher)
        let expectation = XCTestExpectation(description: "API to return back in 2 sec")
        
        service.execute(request: testURL) { (result: Result<NetworkServiceStubModal, Error>) in
            switch result {
            case .success(let response):
                XCTAssert(response.test == testModal.test)
            case .failure(_):
                XCTAssert(false)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testFetcherError() {
        let stubError = StubNetworkServiceError.noInternet
        let stubFetcher = StubRequestFetcher(data: nil, response: nil, error: stubError)
        let service = NetworkRequestExecuter(requestFetcher: stubFetcher)
        let expectation = XCTestExpectation(description: "API to return back in 2 sec")
        
        service.execute(request: testURL){ (result: Result<NetworkServiceStubModal, Error>) in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                XCTAssert(StubNetworkServiceError.noInternet == error as! StubNetworkServiceError)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testDecoder() {
        let testModal = NetworkServiceStubModal(test: "test123")
        let decoder = StubDecoder(stubObject: testModal)
        let fetcher = StubRequestFetcher(data: "MyTest".data(using: .utf8), response: nil, error: nil)
        
        let expectation = XCTestExpectation(description: "API to return back in 2 sec")
        
        let service = NetworkRequestExecuter(requestFetcher: fetcher, decoder: decoder)

        service.execute(request: testURL) { (result: Result<NetworkServiceStubModal, Error>) in
            switch result {
            case .success(let response):
                XCTAssert(response.test == testModal.test)
            case .failure(let error):
                XCTAssert(StubNetworkServiceError.noInternet == error as! StubNetworkServiceError)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
}
