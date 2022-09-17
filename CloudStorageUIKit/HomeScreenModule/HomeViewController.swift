//
//  HomeViewController.swift
//  CIViperGenerator
//
//  Created by Eronin Fedor on 11.09.2022.
//  Copyright © 2022 Eronin Fedor. All rights reserved.
//

import UIKit
import FirebaseStorage
import MobileCoreServices
import UniformTypeIdentifiers

protocol HomeViewControllerInterface: AnyObject {

}

class HomeViewController: UIViewController {
    var presenter: HomePresenterInterface?
    
    private lazy var emailLabel: UILabel = {
        let emailLabel = UILabel()
        emailLabel.adjustsFontSizeToFitWidth = true
        return emailLabel
    }()
    
    private lazy var selectMediaButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Media", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var documentPicker: UIDocumentPickerViewController = {
        let documentPicker = UIDocumentPickerViewController()
        return documentPicker
    }()
    
    private lazy var mediaPicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.mediaTypes = ["public.image", "public.movie"]
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .pageSheet
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        ssetupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(emailLabel)
        view.addSubview(selectMediaButton)
    }
    
    private func ssetupConstraints() {
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        selectMediaButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(48)
            make.height.equalTo(48)
        }
    }
    
    private func uploadImage(image: UIImage) {
        let randomID = UUID().uuidString
        let uploadRef = Storage.storage().reference().child("\(randomID).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        uploadRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("error")
                print(error.localizedDescription)
                return
            }
            print("upload is done\(metadata)")
        }
    }
    
    private func getStorageInfo() {
        let storageRef = Storage.storage().reference().child("aboba")
        storageRef.listAll { result, error in
            guard let result  = result else { return }
            result.prefixes.forEach { ref in
                print(ref)
            }
            result.items.forEach { ref in
                print(ref)
            }
        }
    }
    
    @objc private func selectButtonTapped() {
//        self.present(mediaPicker, animated: true)
//        getStorageInfo()
  
    
    }
}

extension HomeViewController: HomeViewControllerInterface {

}

extension HomeViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.originalImage] as? UIImage else { return }
        uploadImage(image: image)
        dismiss(animated: true)
    }
}
