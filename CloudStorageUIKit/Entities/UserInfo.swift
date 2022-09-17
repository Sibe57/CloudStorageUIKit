//
//  UserInfo.swift
//  CloudStorageUIKit
//
//  Created by Федор Еронин on 11.09.2022.
//

import Foundation
import Firebase

class UserInfo {
    
    static let shared = UserInfo()
    
    var userID: String? = {
        let auth = Auth.auth()
        return auth.currentUser?.uid
    }()
    
    var email: String? = {
        let auth = Auth.auth()
        return auth.currentUser?.email
    }()
    
    var token: String?
    
    private init() {}
    
    func getToken(completion: @escaping (Error?) -> Void = { _ in }) {
        let auth = Auth.auth()
        auth.currentUser?.getIDToken(completion: { token, error in
            guard error == nil else {
                completion(error)
                return
            }
            self.token = token
            completion(nil)
        })
    }
}
