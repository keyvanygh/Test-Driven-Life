//
//  Dictinary + extension.swift
//  HomeTests
//
//  Created by Keyvan Yaghoubian on 9/19/24.
//

import Foundation

extension [String: Any] {
    var data: Data {
        return try! JSONSerialization.data(withJSONObject: self)
    }
}
extension [String: String] {
    static let dummy = ["anyKey": "anyValue"]
    
    func isSubset(of dict: Self) -> Bool {
        self.allSatisfy({ dict[$0.key] == $0.value })
    }
}
