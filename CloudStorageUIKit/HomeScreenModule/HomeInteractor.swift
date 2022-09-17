//
//  HomeInteractor.swift
//  CIViperGenerator
//
//  Created by Eronin Fedor on 11.09.2022.
//  Copyright © 2022 Eronin Fedor. All rights reserved.
//

import Foundation

protocol HomeInteractorInterface: AnyObject {

}

class HomeInteractor {
    weak var presenter: HomePresenterInterface?
}

extension HomeInteractor: HomeInteractorInterface {

}
