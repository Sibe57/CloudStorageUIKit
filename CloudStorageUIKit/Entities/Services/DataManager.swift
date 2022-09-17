//
//  DataManager.swift
//  CloudStorageUIKit
//
//  Created by Федор Еронин on 17.09.2022.
//

import FirebaseStorage
import UIKit


class DataManager {
    static let shared = DataManager()
    
    let storage = Storage.storage()
    lazy var storageRef = storage.reference()
    private init() {}
    
    
    func uploadFile(url: URL, name: String, in folder: String = "") {
        guard UploadDataValidator.validateFileExtension(url) && UploadDataValidator.validateFileSize(url)
        else {
            return
        }
        
        let randomID = UUID().uuidString
        let uploadRef = storageRef.child(folder).child(randomID)
        
        uploadRef.putFile(from: url, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                if let error = error { print(error.localizedDescription) }
                return
            }
            UserDefaults.standard.set(name, forKey: randomID)
            print(metadata)
        }
    }
    
    func getStorageInfo(in folder: String = "", completion: @escaping (StorageListResult) -> Void) {
        let storageRef = storageRef.child(folder)
        
        storageRef.listAll { result, error in
            guard let result = result else {
                if let error = error { print(error.localizedDescription) }
                return
            }
            completion(result)
            print(result)
        }
    }
}

