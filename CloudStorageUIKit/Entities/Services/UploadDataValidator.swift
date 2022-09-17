//
//  UploadDataValidator.swift
//  CloudStorageUIKit
//
//  Created by Федор Еронин on 17.09.2022.
//

import Foundation

class UploadDataValidator {
    
    static func validateFileSize(_ url: URL) -> Bool {
        let limit = 20 * 1024 * 1024
        let isValidate = url.fileSize >= limit ? false : true
        return isValidate
    }

    static func validateFileExtension(_ url: URL) -> Bool {
        return url.pathExtension == "txt" ? false : true
    }
    
}

