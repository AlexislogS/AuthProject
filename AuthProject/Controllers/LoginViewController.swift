//
//  LoginViewController.swift
//  AuthProject
//
//  Created by Alex Yatsenko on 10.09.2020.
//  Copyright © 2020 AlexislogS. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController, SignScreenFactory {

    private lazy var emailTextField: UITextField = {
        let textField = makeTextField(with: "Email")
        configure(textFiled: textField)
        return textField
    }()
    private lazy var passwordTextField: UITextField = {
        let textField = makeTextField(with: "Password")
        configure(textFiled: textField)
        return textField
    }()
    private lazy var loginButton: UIButton = {
        let button = makeButton(with: ButtonTitle.login)
        button.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        button.alpha = 0.5
        return button
    }()
    private lazy var backButton: UIButton = {
        let button = makeButton(with: "Back")
        button.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        return button
    }()
    private lazy var buttonsStackView: UIStackView = {
        let stackView = makeStackView(with: 20)
        if view.bounds.height < view.bounds.width {
            stackView.axis = .horizontal
        }
        return stackView
    }()
    private lazy var textFieldsStackView: UIStackView = {
        let stackView = makeStackView(with: 20)
        if view.bounds.height < view.bounds.width {
            stackView.axis = .horizontal
        }
        return stackView
    }()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .black
        return indicator
    }()
    private lazy var headLabel: UILabel = {
        let label = makeLabel(with: "Alexislog's App", and: 45)
        return label
    }()
    
    private var contentViewSize: CGSize {
        if let navBar = navigationController?.navigationBar {
            return CGSize(width: view.bounds.width,
                          height: view.bounds.height - navBar.bounds.width)
        }
        return view.bounds.size
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        scrollView.contentSize = contentViewSize
        return scrollView
    }()
    
    private let spacerView = UIView()
    private let firebaseManager: FirebaseManager
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        configureSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleDidShow(notification:)),
                                               name: UITextField.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleDidHide(notification:)),
                                               name: UITextField.keyboardDidHideNotification,
                                               object: nil)
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if size.width > size.height {
            buttonsStackView.insertArrangedSubview(spacerView, at: 1)
            buttonsStackView.axis = .horizontal
            textFieldsStackView.axis = .horizontal
        } else {
            buttonsStackView.removeArrangedSubview(spacerView)
            buttonsStackView.axis = .vertical
            textFieldsStackView.axis = .vertical
        }
    }
    
    private func configureSubViews() {
        
        // MARK: - Add subViews to view hierarchy
        
        view.addSubview(scrollView)

        buttonsStackView.addArrangedSubview(loginButton)
        if view.bounds.width > view.bounds.height {
            buttonsStackView.addArrangedSubview(spacerView)
        }
        buttonsStackView.addArrangedSubview(backButton)
        
        textFieldsStackView.addArrangedSubview(emailTextField)
        textFieldsStackView.addArrangedSubview(passwordTextField)
        
        scrollView.addSubview(headLabel)
        scrollView.addSubview(textFieldsStackView)
        scrollView.addSubview(buttonsStackView)

        loginButton.addSubview(activityIndicator)
        
        // MARK: - Constraints
        
        constraintSubviews()
    }
    
    private func configure(textFiled: UITextField) {
        textFiled.delegate = self
        textFiled.addTarget(self, action: #selector(isTextFieldsFilled), for: .editingChanged)
    }
    
    private func constraintSubviews() {
        scrollView.fillSuperview()
        
        headLabel.anchors(top: scrollView.topAnchor,
                          centerX: scrollView.centerXAnchor,
                          padding: .init(top: 50, left: 0, bottom: 0, right: 0))
        headLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
        textFieldsStackView.anchors(top: headLabel.bottomAnchor,
                                    leading: scrollView.safeAreaLayoutGuide.leadingAnchor,
                                    trailing: scrollView.safeAreaLayoutGuide.trailingAnchor,
                                    padding: .init(top: 20, left: 40, bottom: 0, right: 40))
        
        buttonsStackView.anchors(top: textFieldsStackView.bottomAnchor,
                                 leading: scrollView.safeAreaLayoutGuide.leadingAnchor,
                                 trailing: scrollView.safeAreaLayoutGuide.trailingAnchor,
                                 padding: .init(top: 40, left: 120, bottom: 0, right: 120))
        
        activityIndicator.anchors(centerX: loginButton.centerXAnchor,
                                  centerY: loginButton.centerYAnchor)
    }
    
    private func validateInput() -> Bool {
        if isTextFieldsFilled() {
            if FieldsValidator.isValidEmail(emailTextField.text!) {
                loginButton.setTitle("", for: .normal)
                loginButton.alpha = 0.5
                activityIndicator.startAnimating()
                return true
            }
            showAlert(wit: "Wrong input", and:  "Invalid email")
            return false
        }
        showAlert(wit: "Wrong input", and:  "Please fill in all fields")
        return false
    }
    
    @objc private func isTextFieldsFilled() -> Bool {
        if FieldsValidator.isFilledLogin(emailTF: emailTextField,
                               passwordTF: passwordTextField) {
            loginButton.alpha = 1
            return true
        } else {
            loginButton.alpha = 0.5
            return false
        }
    }
    
    @objc private func loginPressed() {
        guard validateInput() else { return }
        firebaseManager.authorizeUser(by: emailTextField.text!,
                                      and: passwordTextField.text!) { [weak self] result in
                                        guard let self = self else { return }
                                        switch result {
                                        case .success():
                                            self.showUserScreen(firebaseManager: self.firebaseManager)
                                        case .failure(let error):
                                            self.showAlert(
                                                wit: "Failed to login",
                                                and: error.localizedDescription
                                            ) {
                                                self.loginButton.setTitle(ButtonTitle.login,
                                                                           for: .normal)
                                                self.loginButton.alpha = 1
                                                self.activityIndicator.stopAnimating()
                                            }
                                        }
        }
    }
    
    @objc private func backPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleDidShow(notification: Notification) {
        if let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UITextField.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.scrollView.isScrollEnabled = true
            self.scrollView.contentSize = CGSize(
                width: self.view.bounds.width,
                height: self.view.bounds.height + keyboardFrame.height
            )
            let bottomInset: CGFloat
            if self.navigationController?.navigationBar != nil {
                bottomInset = keyboardFrame.height - self.navigationController!.navigationBar.bounds.height
            } else {
                bottomInset = keyboardFrame.height
            }
            self.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                                 left: 0,
                                                                 bottom: bottomInset,
                                                                 right: 0)
        }
    }
        
    @objc private func handleDidHide(notification: Notification) {
        UIView.transition(with: scrollView,
                          duration: 0.3,
                          options: .curveEaseOut,
                          animations: {
                            self.scrollView.contentSize = self.contentViewSize
        }, completion: { _ in
            self.scrollView.isScrollEnabled = false
        })
    }
    
}

    // MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            loginPressed()
        default:
            break
        }
        return true
    }
}
