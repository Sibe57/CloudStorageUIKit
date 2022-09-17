//
//  UIViewShadowExtention.swift
//  CloudStorageUIKit
//
//  Created by Федор Еронин on 17.09.2022.
//

import UIKit

extension UIView {
    func setShadow() {
        layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 8
    }
}
