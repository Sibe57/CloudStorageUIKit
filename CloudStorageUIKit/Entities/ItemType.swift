//
//  ItemType.swift
//  CloudStorageUIKit
//
//  Created by Федор Еронин on 17.09.2022.
//

import Foundation
import FirebaseStorage

enum ItemType {
    case file
    case folder
}

struct StorageItem {
    let type: ItemType
    let ref: StorageReference
    var name: String {
        UserDefaults.standard.string(forKey: ref.name) ?? ref.name
    }
}
