//
//  AuthViewModel.swift
//  CloudStorageUIKit
//
//  Created by Федор Еронин on 11.09.2022.
//

import Foundation
import FirebaseAuth

class AuthViewModel {
    
    weak var view: AuthViewControllerInterface?
    
    let user: UserInfo
    let auth = Auth.auth()
    
    init(user: UserInfo) {
        self.user = user
    }

    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { result, error in
            
            guard error == nil else {
                self.view?.showAlert(withTitle: error?.localizedDescription ?? "UnknownError")
                return
            }
            self.user.userID = result?.user.uid
            self.user.email = result?.user.email
            self.user.getToken()
            self.view?.showAlert(withTitle: "Hello \(result?.user.email)")
            UserDefaults.standard.set(self.user.email ?? "", forKey: "userEmail")
        }
    }

    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { []result, error in
            guard error == nil else {
                self.view?.showAlert(withTitle: error?.localizedDescription ?? "UnknownError")
                return
            }
            print("Your Account has been successfully created")
            self.signIn(email: email, password: password)
        }
    }
    
    func viewDidLoad() {
        if let usersEmail = UserDefaults.standard.object(forKey: "userEmail") as? String {
            
            view?.setEmailTextField(withText: usersEmail)
        } else {
            view?.setEmailTextField(withText: "")
        }
    }
}
