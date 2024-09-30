//
//  HTTPURLResponse + extension.swift
//  HomeTests
//
//  Created by Keyvan Yaghoubian on 9/19/24.
//

import Foundation

extension HTTPURLResponse {
    static let ok_200 = HTTPURLResponse(url: .dummy, statusCode: 200, httpVersion: nil, headerFields: nil)!
    
    convenience init(statusCode: Int) {
        self.init(url: .dummy, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
