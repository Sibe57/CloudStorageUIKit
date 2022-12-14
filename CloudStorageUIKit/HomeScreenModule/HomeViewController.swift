//
//  HomeViewController.swift
//  CIViperGenerator
//
//  Created by Eronin Fedor on 11.09.2022.
//  Copyright © 2022 Eronin Fedor. All rights reserved.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

protocol HomeViewControllerInterface: AnyObject {
    func reloadView(showBackButton: Bool)
    func showRenameAlert()
    func showErrorAlert(error: String)
}

class HomeViewController: UIViewController {
    var presenter: HomePresenterInterface?
    
    private lazy var backChevron: UIButton = {
        let backCevron = UIButton(type: .system)
        backCevron.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backCevron.addTarget(self, action: #selector(backChevronTapped), for: .touchUpInside)
        backCevron.isHidden = true
        return backCevron
    }()
    
    private lazy var emailLabel: UILabel = {
        let emailLabel = UILabel()
        emailLabel.adjustsFontSizeToFitWidth = true
        emailLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        emailLabel.textAlignment = .center
        return emailLabel
    }()
    
    private lazy var selectMediaButton: UIButton = {
        let button = UIButton(type: .system)
        button.setCSAppearance()
        button.setTitle("Select Media", for: .normal)
        button.addTarget(self, action: #selector(selectMediaTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var selectFileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setCSAppearance()
        button.setTitle("Select File", for: .normal)
        button.addTarget(self, action: #selector(selectFileTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var documentPicker: UIDocumentPickerViewController = {
        let documentPicker = UIDocumentPickerViewController(
            forOpeningContentTypes: [.text, .archive, .image, .audiovisualContent, .audio]
        )
        documentPicker.delegate = self
        return documentPicker
    }()
    
    private lazy var mediaPicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = ["public.image", "public.movie"]
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .pageSheet
        return picker
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(selectMediaButton)
        stack.addArrangedSubview(selectFileButton)
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        button.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = ((view.window?.frame.width ?? 375) - (4 * 4) - 48) / 5
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FileFolderCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
// MARK: - VC Life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        presenter?.viewDidLoad()
        emailLabel.text = UserInfo.shared.email
        navigationController?.setNavigationBarHidden(true, animated: false)
        collectionView.dataSource = self
        collectionView.delegate = self
        setupViews()
        setupConstraints()
    }

// MARK: - Private methods
        
    private func setupViews() {
        view.addSubview(emailLabel)
        view.addSubview(buttonStack)
        view.addSubview(collectionView)
        view.addSubview(backChevron)
        view.addSubview(settingsButton)
    }
    
    private func setupConstraints() {
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        backChevron.snp.makeConstraints { make in
            make.centerY.equalTo(emailLabel)
            make.left.equalToSuperview().inset(24)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).inset(-16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(buttonStack.snp.top).inset(-16)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.centerY.equalTo(emailLabel)
            make.right.equalToSuperview().inset(24)
        }
    }
    
    private func showNameAlert() {
        
        // FireStorage dont support empty folder because of this, if user wants to create newFolder he can mark it in the file name
        let alert = UIAlertController(
            title: "Enter file name",
            message: "If you want upload file in new folder yor name must be \"newFolder/myFile\"",
            preferredStyle: .alert)
        alert.addTextField()
        
        guard let textField = alert.textFields?.first else { return }

        let alertUploadAction = UIAlertAction(title: "Upload", style: .default) { _ in
            self.presenter?.tryUploadFile(with: textField.text ?? "")
        }
        let alertCancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.presenter?.setSelectedURL(url: nil)
        }
        alert.addAction(alertUploadAction)
        alert.addAction(alertCancelAction)
        self.present(alert, animated: true)
    }
    
// MARK: - @objc methods
    
    @objc private func selectMediaTapped() {
        self.present(mediaPicker, animated: true)
    }
    
    @objc private func selectFileTapped() {
        self.present(documentPicker, animated: true)
    }
    
    @objc private func backChevronTapped() {
        presenter?.backChevronTapped()
    }
    
    @objc private func settingsTapped() {
        print("settings tapped")
    }
}

// MARK: - HomeViewControllerInterface Extention

extension HomeViewController: HomeViewControllerInterface {
    
    func reloadView(showBackButton: Bool) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) { [self] in
            collectionView.alpha = 0
        } completion: { [self] _ in
            collectionView.reloadData()
            UIView.animate(withDuration: 0.10, delay: 0, options: .curveEaseOut) { [self] in
                collectionView.alpha = 1
            }
        }
        backChevron.isHidden = !showBackButton
    }
    func showRenameAlert() {
        let alert = UIAlertController(
            title: "Rename this file",
            message: "Enter new file name",
            preferredStyle: .alert)
        alert.addTextField() {
            $0.placeholder = "New file name"
        }
        
        guard let textField = alert.textFields?.first else { return }

        let alertUploadAction = UIAlertAction(title: "Rename", style: .default) { _ in
            guard let text = textField.text, text != "" else { return }
            let standartText = text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ".", with: "")
            print(standartText)
            self.presenter?.renameFile(newName: standartText)
            print("fileRenaming")
        }
        let alertCancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
        }
        
        let alertDeleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.presenter?.delDidTapped()
        }
        alert.addAction(alertUploadAction)
        alert.addAction(alertCancelAction)
        alert.addAction(alertDeleteAction)
        self.present(alert, animated: true)
    }
    
    func showErrorAlert(error: String) {
        
        let alert = UIAlertController(
            title: "Oh now Error",
            message: error,
            preferredStyle: .alert)
       
        let alertOkAction = UIAlertAction(title: "Ok", style: .destructive) { _ in
            self.presenter?.setSelectedURL(url: nil)
        }
        alert.addAction(alertOkAction)
        self.present(alert, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate Extention

extension HomeViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let url = info[.imageURL] as? URL else { return }
        print(url)
        presenter?.setSelectedURL(url: url)
        dismiss(animated: true)
        showNameAlert()
    }
}

// MARK: - UIDocumentPickerDelegate Extention

extension HomeViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        presenter?.setSelectedURL(url: url)
        dismiss(animated: true)
        showNameAlert()
    }
}

// MARK: - UICollectionViewDelegate Extention

extension HomeViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource Extention

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.getNumbersOfCells() ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                as? FileFolderCell,
              let itemInfo = presenter?.configureCell(at: indexPath)
        else { return UICollectionViewCell() }
        cell.configure(name: itemInfo.name, type: itemInfo.type)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.itemDidTapped(at: indexPath)
    }
}
