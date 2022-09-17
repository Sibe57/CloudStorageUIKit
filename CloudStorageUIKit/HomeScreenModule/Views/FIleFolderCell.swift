//
//  FIleFolderCell.swift
//  CloudStorageUIKit
//
//  Created by Федор Еронин on 17.09.2022.
//

import UIKit
import FirebaseStorage

class FileFolderCell: UICollectionViewCell {
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var bottomLabel: UILabel = {
        let bottomLabel = UILabel()
        bottomLabel.font = UIFont.systemFont(ofSize: 13)
        bottomLabel.textAlignment = .center
        //bottomLabel.adjustsFontSizeToFitWidth = true
        bottomLabel.numberOfLines = 2
        bottomLabel.lineBreakMode = .byTruncatingMiddle
        return bottomLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(image)
        contentView.addSubview(bottomLabel)
    }
    
    private func setupConstraints() {
        image.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(bottomLabel.snp.top)
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(24)
        }
    }
    
    func configure(name: String, type: ItemType) {
        switch type {
        case .file:
            image.image = UIImage(systemName: "doc.text.fill")
        case .folder:
            image.image = UIImage(systemName: "folder")
        }
        bottomLabel.text = name
    }
}
