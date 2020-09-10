//
//  SignScreenFactory.swift
//  AuthProject
//
//  Created by Alex Yatsenko on 10.09.2020.
//  Copyright © 2020 AlexislogS. All rights reserved.
//

import UIKit

protocol SignScreenFactory {
    func makeTextField(with placeHolder: String) -> UITextField
    func makeButton(with title: String) -> UIButton
    func makeStackView(with spacing: CGFloat) -> UIStackView
    func makeLabel(with title: String, and size: CGFloat) -> UILabel
    func makeImageView() -> UIImageView
}

extension SignScreenFactory {

    func makeTextField(with placeHolder: String) -> UITextField {
        let textFiled = UITextField()
        textFiled.placeholder = placeHolder
        textFiled.backgroundColor = .white
        textFiled.returnKeyType = .next
        textFiled.autocorrectionType = .no
        textFiled.smartQuotesType = .no
        if placeHolder == "Password" {
            textFiled.textContentType = .password
            textFiled.isSecureTextEntry = true
            textFiled.returnKeyType = .join
        } else if placeHolder == "Email" {
            textFiled.autocapitalizationType = .none
            textFiled.keyboardType = .emailAddress
        }
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        textFiled.heightAnchor.constraint(equalToConstant: 34).isActive = true
        return textFiled
    }
    
    func makeButton(with title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 5
        button.setTitle(title, for: .normal)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }
    
    func makeStackView(with spacing: CGFloat) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = spacing
        stack.distribution = .fillEqually
        return stack
    }
    
    func makeLabel(with title: String, and size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    func makeImageView() -> UIImageView {
        let imageView = UIImageView(image: Image.placeholder)
        imageView.layer.cornerRadius = 10
        imageView.tintColor = .white
        imageView.backgroundColor = .gray
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }
    
    func showUserScreen(firebaseManager: FirebaseManager) {
        let userVC = UINavigationController(rootViewController: UserViewController(firebaseManager: firebaseManager))
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = userVC
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
