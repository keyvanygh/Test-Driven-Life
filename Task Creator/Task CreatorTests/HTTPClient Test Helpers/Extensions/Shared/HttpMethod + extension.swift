//
//  HttpMethod + extension.swift
//
//
//  Created by Keyvan Yaghoubian on 9/21/24.
//

import Foundation
import HttpClient

extension HttpMethod {
    var canHaveBody: Bool {
        return self != .GET && self != .HEAD
    }
}
