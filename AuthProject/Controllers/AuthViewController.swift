//
//  AuthViewController.swift
//  AuthProject
//
//  Created by Alex Yatsenko on 10.09.2020.
//  Copyright © 2020 AlexislogS. All rights reserved.
//

import UIKit

final class AuthViewController: UIViewController, SignScreenFactory {
    
    private lazy var loginButton: UIButton = {
        let button = makeButton(with: ButtonTitle.login)
        button.addTarget(self, action: #selector(showLogin), for: .touchUpInside)
        return button
    }()
    private lazy var signUpButton: UIButton = {
        let button = makeButton(with: ButtonTitle.signUp)
        button.addTarget(self, action: #selector(showSignUp), for: .touchUpInside)
        return button
    }()
    private lazy var buttonsStackView: UIStackView = {
        let stack = makeStackView(with: 30)
        return stack
    }()
    
    private var vcFactory: ViewControllerFactoryImpl {
        return (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).vcFactory
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .lightGray
        configureViews()
    }
    
    private func configureViews() {
        let titleLabel = makeLabel(with: "AuthProject", and: 50)
        
        [titleLabel, buttonsStackView].forEach { view.addSubview($0) }
        [loginButton, signUpButton].forEach { buttonsStackView.addArrangedSubview($0) }
        
        titleLabel.anchors(top: view.safeAreaLayoutGuide.topAnchor,
                           centerX: view.centerXAnchor,
                           padding: .init(top: 100, left: 0, bottom: 0, right: 0))
        
        buttonsStackView.anchors(leading: view.safeAreaLayoutGuide.leadingAnchor,
                                 trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                 bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                 padding: .init(top: 0, left: 100, bottom: 40, right: 100))
    }

    @objc private func showLogin() {
        navigationController?.pushViewController(vcFactory.makeLoginVC(), animated: true)
    }
    
    @objc private func showSignUp() {
        navigationController?.pushViewController(vcFactory.makeSignupVC(), animated: true)
    }
}
