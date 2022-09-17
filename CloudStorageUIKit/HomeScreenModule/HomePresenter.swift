//
//  HomePresenter.swift
//  CIViperGenerator
//
//  Created by Eronin Fedor on 11.09.2022.
//  Copyright © 2022 Eronin Fedor. All rights reserved.
//

import Foundation
import FirebaseStorage

protocol HomePresenterInterface: AnyObject {
    
    func viewDidLoad()
    
    func getNumbersOfCells() -> Int
    
    func interactorDoneWithData(list: StorageListResult)
    
    func configureCell(at index: IndexPath) -> (name: String, type: ItemType)
    
    func tryUploadFile(with userInput: String)
    
    func setSelectedURL(url: URL?)

}

class HomePresenter {
    
    var currentPath: String = ""
    
    var selectedURLToDeviceFile: URL?
    
    var storageItems: [StorageItem] = []

    unowned var view: HomeViewControllerInterface
    let router: HomeRouterInterface?
    let interactor: HomeInteractorInterface?

    init(
        interactor: HomeInteractorInterface,
        router: HomeRouterInterface,
        view: HomeViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension HomePresenter: HomePresenterInterface {
    func tryUploadFile(with userInput: String) {
        guard let url = selectedURLToDeviceFile else { return }
        let pathComponents = userInput.split(separator: "/").map { String($0) }
        guard pathComponents.count < 3, let name = pathComponents.last else { return }
        DataManager.shared.uploadFile(
            url: url, name: name,
            in: currentPath + (pathComponents.count == 2 ? pathComponents.first ?? "" : "")
        )
    }
    
    func viewDidLoad() {
        interactor?.getListOfItem(in: currentPath)
    }
    
    func interactorDoneWithData(list: StorageListResult) {
        list.prefixes.forEach { storageItems.append(StorageItem(type: .folder, ref: $0)) }
        list.items.forEach { storageItems.append(StorageItem(type: .file, ref: $0)) }
        view.reloadView()
    }
    
    func getNumbersOfCells() -> Int {
        print(storageItems.count)
        return storageItems.count
    }
    
    func configureCell(at index: IndexPath) -> (name: String, type: ItemType) {
        let storageItem = storageItems[index.item]
        return (name: storageItem.name, type: storageItem.type)
    }
    
    func setSelectedURL(url: URL?) {
        selectedURLToDeviceFile = url
    }
}
