//
//  URLRequest + extension.swift
//  Task CreatorTests
//
//  Created by Keyvan Yaghoubian on 9/30/24.
//

import Foundation
import Task_Creator
import HttpClient

extension URLRequest {
    init(url: URL, with parameters: TaskCreationParameters) {
        self.init(url: url)
        self.httpMethod = HttpMethod.POST.rawValue
        self.allHTTPHeaderFields = [:]
        self.httpBody = try? JSONEncoder().encode(APITaskModel(title: parameters.title))
    }
}
