//
//  DataManager.swift
//  CloudStorageUIKit
//
//  Created by Федор Еронин on 17.09.2022.
//

import FirebaseStorage
import UIKit

enum RequestResult {
    case succes
    case failure (description: String)
}
class DataManager {
    static let shared = DataManager()
    
    let storage = Storage.storage()
    lazy var storageRef = storage.reference().child("users").child(UserInfo.shared.userID ?? "")
    private init() {}
    
    
    func uploadFile(url: URL, name: String, in folder: String = "", completion: @escaping (RequestResult) -> Void) {
        guard UploadDataValidator.validateFileExtension(url) && UploadDataValidator.validateFileSize(url)
        else {
            completion(.failure(description: "max size limit or txt file detected"))
            return
        }
        
        let randomID = UUID().uuidString
        let uploadRef = storageRef.child(folder).child(randomID)
        uploadRef.putFile(from: url, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(description: error.localizedDescription))
                }
                return
            }
            UserDefaults.standard.set(name, forKey: randomID)
            print(metadata)
            completion(.succes)
        }
    }
    
    func getStorageInfo(in folder: String = "", completion: @escaping (StorageListResult?, RequestResult) -> Void) {
        let storageRef = storageRef.child(folder)
        storageRef.listAll { result, error in
            guard let result = result else {
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil, .failure(description: error.localizedDescription))
                }
                return
            }
            completion(result, .succes)
            print("hereee")
        }
    }
    
    func deliteFile(on ref: StorageReference, completion: @escaping (RequestResult) -> Void) {
        ref.delete { error in
            if let error  = error {
                completion(.failure(description: error.localizedDescription))
            } else {
                completion(.succes)
            }
        }
    }
    
    func renameFile(with originalName: String, newName: String) {
        UserDefaults.standard.set(newName, forKey: originalName)
    }
}

