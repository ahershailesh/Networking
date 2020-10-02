//
//  StubDecoder.swift
//  NewsAppTests
//
//  Created by Shailesh Aher on 22/09/20.
//  Copyright © 2020 Shailesh Aher. All rights reserved.
//

import Foundation
@testable import Networking

class StubDecoder: Decoder {
    let stubObject: Decodable
    init(stubObject: Decodable) {
        self.stubObject = stubObject
    }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        return stubObject as! T
    }
}
