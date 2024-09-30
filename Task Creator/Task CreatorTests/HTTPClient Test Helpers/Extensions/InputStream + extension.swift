//
//  InputStream + extension.swift
//
//
//  Created by Keyvan Yaghoubian on 9/20/24.
//

import Foundation

extension InputStream {
    var data: Data {
        var data = Data()
        open()
        let bufferSize = 1024
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        while hasBytesAvailable {
            let length = read(&buffer, maxLength: bufferSize)
            if length > 0 {
                data.append(buffer, count: length)
            }
        }
        close()
        return data
    }
}
