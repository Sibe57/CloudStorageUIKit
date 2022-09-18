//
//  AuthViewController.swift
//  CloudStorageUIKit
//
//  Created by Федор Еронин on 11.09.2022.
//

import UIKit
import SnapKit

protocol AuthViewControllerInterface: AnyObject {
    func showAlert(withTitle: String)
    func setEmailTextField(withText: String)
    func goToHomeScreen()
}

class AuthViewController: UIViewController {
    
    var model: AuthViewModel?
    
    private lazy var loginTextFieldBG: UIView = {
        createBGView()
    }()
    
    private lazy var passTextFieldBG: UIView = {
        createBGView()
    }()
    
    
    private lazy var loginTextField: UITextField = {
        let loginTextField = UITextField()
        loginTextField.placeholder = "Email"
        loginTextField.backgroundColor = .white
        loginTextField.keyboardType = .emailAddress
        return loginTextField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.backgroundColor = .white
        passwordTextField.isSecureTextEntry = true
        return passwordTextField
    }()
    
    private lazy var signInButton: UIButton = {
        let signInButton = UIButton(type: .system)
        signInButton.setCSAppearance()
        signInButton.setTitle("SING IN", for: .normal)
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        return signInButton
    }()
    
    private lazy var signUpButton: UIButton = {
        let signUpButton = UIButton(type: .system)
        signUpButton.setCSAppearance()
        signUpButton.setTitle("SING UP", for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return signUpButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = AuthViewModel(user: UserInfo.shared)
        model?.view = self
        model?.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.addSubviews(signInButton, signUpButton, loginTextFieldBG, passTextFieldBG)
        loginTextFieldBG.addSubview(loginTextField)
        passTextFieldBG.addSubview(passwordTextField)
    }
    
    private func setupConstraints() {
        loginTextFieldBG.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(160)
            make.height.equalTo(36)
        }
        
        passTextFieldBG.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(loginTextFieldBG.snp.bottom).inset(-24)
            make.height.equalTo(36)
        }
        
        signInButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(60)
            make.top.equalTo(passwordTextField.snp.bottom).inset(-48)
            make.height.equalTo(48)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(60)
            make.top.equalTo(signInButton.snp.bottom).inset(-16)
            make.height.equalTo(48)
        }
        
        loginTextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func createBGView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .continuous
        view.setShadow()
        return view
    }
    
    @objc private func signInTapped() {
        model?.signIn(email: loginTextField.text ?? "", password: passwordTextField.text ?? "")
    }
    
    @objc private func signUpTapped() {
        model?.signUp(email: loginTextField.text ?? "", password: passwordTextField.text ?? "")
    }
}

extension AuthViewController: AuthViewControllerInterface {
    func goToHomeScreen() {
        navigationController?.pushViewController(HomeRouter.setupModule(), animated: true)
    }
    
    func showAlert(withTitle: String) {
        let alert = UIAlertController(title: withTitle, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func setEmailTextField(withText: String) {
        loginTextField.text = withText
    }
}
