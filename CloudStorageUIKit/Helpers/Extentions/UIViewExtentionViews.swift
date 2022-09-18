//
//  UIViewExtentionViews.swift
//  CloudStorageUIKit
//
//  Created by Федор Еронин on 18.09.2022.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
