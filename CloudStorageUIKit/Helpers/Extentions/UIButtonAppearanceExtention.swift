//
//  UIButtonAppearanceExtention.swift
//  CloudStorageUIKit
//
//  Created by Федор Еронин on 17.09.2022.
//

import UIKit

extension UIButton {
    func setCSAppearance() {
        backgroundColor = .systemBlue
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        layer.cornerRadius = 13
        layer.cornerCurve = .continuous
        setShadow()
    }
}
