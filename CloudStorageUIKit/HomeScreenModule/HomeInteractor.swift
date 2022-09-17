//
//  HomeInteractor.swift
//  CIViperGenerator
//
//  Created by Eronin Fedor on 11.09.2022.
//  Copyright © 2022 Eronin Fedor. All rights reserved.
//

import Foundation

protocol HomeInteractorInterface: AnyObject {
    func getListOfItem(in folder: String)
}

class HomeInteractor {
    weak var presenter: HomePresenterInterface?
}

extension HomeInteractor: HomeInteractorInterface {
    
    // leave folder arg to default to get all files from root folder
    func getListOfItem(in folder: String = "") {
        DataManager.shared.getStorageInfo(in: folder) { [weak self] result in
            self?.presenter?.interactorDoneWithData(list: result)
        }
    }

}
