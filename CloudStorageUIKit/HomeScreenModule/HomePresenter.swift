//
//  HomePresenter.swift
//  CIViperGenerator
//
//  Created by Eronin Fedor on 11.09.2022.
//  Copyright © 2022 Eronin Fedor. All rights reserved.
//

import Foundation

protocol HomePresenterInterface: AnyObject {

}

class HomePresenter {

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

}
