//
//  HomePresenter.swift
//  CIViperGenerator
//
//  Created by Eronin Fedor on 11.09.2022.
//  Copyright © 2022 Eronin Fedor. All rights reserved.
//

import UIKit
import FirebaseStorage

protocol HomePresenterInterface: AnyObject {
    
    func viewDidLoad()
    
    func getNumbersOfCells() -> Int
    
    func interactorDoneWithData(list: StorageListResult)
    
    func configureCell(at index: IndexPath) -> (name: String, type: ItemType)
    
    func tryUploadFile(with userInput: String)
    
    func setSelectedURL(url: URL?)
    
    func uploadingDone(with result: UploadingResult)
    
    func itemDidTapped(at item: IndexPath)
    
    func backChevronTapped()
    
    func renameFile(newName: String)
}

class HomePresenter {
    
    var currentPath: String = ""
    
    var selectedIndexOfFile: IndexPath?
    
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
    
    func uploadingDone(with result: UploadingResult) {
        switch result {
        case .succes:
            interactor?.getListOfItem(in: currentPath)
        case .failure:
            print("failure")
        }
    }
 
    
    func tryUploadFile(with userInput: String) {
        guard let url = selectedURLToDeviceFile else { return }
        let pathComponents = userInput.split(separator: "/").map { String($0) }
        guard pathComponents.count < 3, let name = pathComponents.last else { return }
        
        interactor?.uploadFile(
            url: url, name: name,
            path: currentPath + "/" + (pathComponents.count == 2 ? pathComponents.first ?? "" : "")
        )
    }
    
    func viewDidLoad() {
        interactor?.getListOfItem(in: currentPath)
    }
    
    func interactorDoneWithData(list: StorageListResult) {
        storageItems = []
        list.prefixes.forEach { storageItems.append(StorageItem(type: .folder, ref: $0)) }
        list.items.forEach { storageItems.append(StorageItem(type: .file, ref: $0)) }
        view.reloadView(showBackButton: currentPath != "")
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
    
    func itemDidTapped(at index: IndexPath) {
        let item = storageItems[index.item]
        switch item.type {
            
        case .file:
            selectedIndexOfFile = index
            view.showRenameAlert()
            
        case .folder:
            currentPath += "/\(item.name)"
            interactor?.getListOfItem(in: currentPath)
        }
    }
    
    func backChevronTapped() {
        guard currentPath != "" else { return }
        var pathComponents = currentPath.components(separatedBy: "/")
        pathComponents.removeLast()
        currentPath = String(pathComponents.joined())
        interactor?.getListOfItem(in: currentPath)
    }
    
    func renameFile(newName: String) {
        guard let index = selectedIndexOfFile?.item else { return }
        interactor?.renameFile(originalName: storageItems[index].ref.name, newName: newName)
        view.reloadView(showBackButton: currentPath != "")
    }
}
