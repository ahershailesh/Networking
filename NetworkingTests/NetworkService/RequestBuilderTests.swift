//
//  RequestBuilderTests.swift
//  NewsAppTests
//
//  Created by Shailesh Aher on 23/09/20.
//  Copyright © 2020 Shailesh Aher. All rights reserved.
//

import XCTest
@testable import Networking

struct StubRequestDataProvider: NetworkRequestDataProvider {
    let path: String
    let type: NetworkRequestType
    var query: [String : String]
    var headers: [String : String]
}

class RequestBuilderTests: XCTestCase {
    
    func testNegativeScenario() {
        let path = ""
        let stubProvider = StubRequestDataProvider(path: path, type: .get, query: [:], headers: [:])
        let serverURL = ""
        let builder = NetworkRequestConstructor(serverURL: serverURL)
        let request = builder.request(with: stubProvider)
        XCTAssertNotNil(request)
    }
    
    func testGetRequest() {
        let path = "/caltender"
        let stubProvider = StubRequestDataProvider(path: path, type: .get, query: [:], headers: [:])
        let serverURL = "www.google.com"
        let builder = NetworkRequestConstructor(serverURL: serverURL)
        let request = builder.request(with: stubProvider)
        XCTAssert(serverURL + path == request?.url?.absoluteString)
        XCTAssert(request?.httpMethod == NetworkRequestType.get.method)
    }
    
    func testPostRequest() {
        let path = "/caltender"
        let bodyResponse = """
{
    "test": "test"
}
"""
        let stubProvider = StubRequestDataProvider(path: path, type: .post(body: bodyResponse), query: [:], headers: [:])
        let serverURL = "www.google.com"
        let builder = NetworkRequestConstructor(serverURL: serverURL)
        let request = builder.request(with: stubProvider)
        XCTAssert(serverURL + path == request?.url?.absoluteString)
        XCTAssert(request?.httpMethod == NetworkRequestType.post(body: "").method)
        XCTAssert(request?.httpBody == bodyResponse.data(using: .utf8))
    }
    
    func testPatchRequest() {
        let path = "/caltender"
        let bodyResponse = """
    {
        "test": "test"
    }
    """
        let stubProvider = StubRequestDataProvider(path: path, type: .patch(body: bodyResponse), query: [:], headers: [:])
        let serverURL = "www.google.com"
        let builder = NetworkRequestConstructor(serverURL: serverURL)
        let request = builder.request(with: stubProvider)
        XCTAssert(serverURL + path == request?.url?.absoluteString)
        XCTAssert(request?.httpMethod == NetworkRequestType.patch(body: "").method)
        XCTAssert(request?.httpBody == bodyResponse.data(using: .utf8))
    }
    
    func testDeleteRequest() {
        let path = "/caltender"
        let stubProvider = StubRequestDataProvider(path: path, type: .delete, query: [:], headers: [:])
        let serverURL = "www.google.com"
        let builder = NetworkRequestConstructor(serverURL: serverURL)
        let request = builder.request(with: stubProvider)
        XCTAssert(serverURL + path == request?.url?.absoluteString)
        XCTAssert(request?.httpMethod == NetworkRequestType.delete.method)
    }
}
