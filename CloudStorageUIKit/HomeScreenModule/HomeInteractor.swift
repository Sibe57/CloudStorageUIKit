//
//  HomeInteractor.swift
//  CIViperGenerator
//
//  Created by Eronin Fedor on 11.09.2022.
//  Copyright © 2022 Eronin Fedor. All rights reserved.
//

import Foundation
import FirebaseStorage

protocol HomeInteractorInterface: AnyObject {
    func getListOfItem(in folder: String)
    func uploadFile(url: URL, name: String, path: String)
    func renameFile(originalName: String, newName: String)
    func delFile(at ref: StorageReference)
}

class HomeInteractor {
    weak var presenter: HomePresenterInterface?
}

extension HomeInteractor: HomeInteractorInterface {
    
    func uploadFile(url: URL, name: String, path: String) {
        DataManager.shared.uploadFile(url: url, name: name, in: path) {
            self.presenter?.uploadingDone(with: $0)
        }
    }
    
    // leave folder arg to default to get all files from root folder
    func getListOfItem(in folder: String = "") {
        DataManager.shared.getStorageInfo(in: folder) { [weak self] list, result  in
            self?.presenter?.interactorDoneWithData(list: list, result: result)
        }
    }
    
    func renameFile(originalName: String, newName: String) {
        DataManager.shared.renameFile(with: originalName, newName: newName)
    }
    
    func delFile(at ref: StorageReference) {
        DataManager.shared.deliteFile(on: ref) { [weak self] in
            self?.presenter?.deleteFileDone(with: $0)
        }
    }

}
