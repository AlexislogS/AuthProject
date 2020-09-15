//
//  RegisterViewController.swift
//  AuthProject
//
//  Created by Alex Yatsenko on 10.09.2020.
//  Copyright © 2020 AlexislogS. All rights reserved.
//

import UIKit

final class RegisterViewController: UIViewController, SignScreenFactory {
    
    private lazy var firstNameTextField: UITextField = {
        let textField = makeTextField(with: "First Name")
        configure(textFiled: textField)
        return textField
    }()
    private lazy var lastNameTextField: UITextField = {
        let textField = makeTextField(with: "Last Name")
        configure(textFiled: textField)
        return textField
    }()
    private lazy var emailTextField: UITextField = {
        let textField = makeTextField(with: "Email")
        configure(textFiled: textField)
        return textField
    }()
    private lazy var passwordTextField: UITextField = {
        let textField = makeTextField(with: "Password")
        configure(textFiled: textField)
        textField.enablesReturnKeyAutomatically = true
        return textField
    }()
    private lazy var signUpButton: UIButton = {
        let button = makeButton(with: ButtonTitle.signUp)
        button.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        button.alpha = 0.5
        return button
    }()
    private lazy var backButton: UIButton = {
        let button = makeButton(with: "Back")
        button.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        return button
    }()
    private lazy var textFieldsStackView: UIStackView = {
        let stackView = makeStackView(with: 20)
        return stackView
    }()
    private lazy var buttonsStackView: UIStackView = {
        let stackView = makeStackView(with: 20)
        stackView.axis = .horizontal
        return stackView
    }()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .black
        return indicator
    }()
    private lazy var headLabel: UILabel = {
        let label = makeLabel(with: "Create Account", and: 40)
        return label
    }()
    
    private var contentViewSize: CGSize {
        if let navBar = navigationController?.navigationBar {
            return CGSize(width: view.bounds.width,
                          height: view.bounds.height - navBar.bounds.width)
        }
        return view.bounds.size
    }
    private var isImageChanged: Bool {
        return profileImageView.image != Image.placeholder
    }
    
    private lazy var profileImageView: UIImageView = {
        let imageView = makeImageView()
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(openCamera(recognizer:))))
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = contentViewSize
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    private var centerProfileImageView: NSLayoutConstraint!
    private var leadingProfileImageView: NSLayoutConstraint!
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleDidShow(notification:)),
                                               name: UITextField.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleDidHide(notification:)),
                                               name: UITextField.keyboardDidHideNotification,
                                               object: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if size.width > size.height {
            centerProfileImageView.isActive = false
            leadingProfileImageView.isActive = true
        } else {
            leadingProfileImageView.isActive = false
            centerProfileImageView.isActive = true
        }
    }
    
    private func configureSubViews() {
        
        // MARK: - Add subViews to view hierarchy
        
        textFieldsStackView.addArrangedSubview(firstNameTextField)
        textFieldsStackView.addArrangedSubview(lastNameTextField)
        textFieldsStackView.addArrangedSubview(emailTextField)
        textFieldsStackView.addArrangedSubview(passwordTextField)
        
        buttonsStackView.addArrangedSubview(signUpButton)
        buttonsStackView.addArrangedSubview(backButton)
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(headLabel)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(textFieldsStackView)
        scrollView.addSubview(buttonsStackView)
        
        signUpButton.addSubview(activityIndicator)
        
        // MARK: - Constraints
        
        constraintSubviews()
    }
    
    private func constraintSubviews() {
        scrollView.fillSuperview()
        
        headLabel.anchors(top: scrollView.centerYAnchor,
                          centerX: scrollView.centerXAnchor,
                          padding: .init(top: -165, left: 0, bottom: 0, right: 0))
        
        centerProfileImageView = profileImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        leadingProfileImageView = profileImageView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 13).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        if view.bounds.height > view.bounds.width {
            centerProfileImageView.isActive = true
        } else {
            leadingProfileImageView.isActive = true
        }
        
        textFieldsStackView.anchors(leading: scrollView.safeAreaLayoutGuide.leadingAnchor,
                                    trailing: scrollView.safeAreaLayoutGuide.trailingAnchor,
                                    padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        textFieldsStackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: 10).isActive = true
        
        buttonsStackView.anchors(top: textFieldsStackView.bottomAnchor,
                                 leading: scrollView.safeAreaLayoutGuide.leadingAnchor,
                                 trailing: scrollView.safeAreaLayoutGuide.trailingAnchor,
                                 padding: .init(top: 20, left: 80, bottom: 0, right: 80))
        
        activityIndicator.anchors(centerX: signUpButton.centerXAnchor,
                                  centerY: signUpButton.centerYAnchor)
    }
    
    private func validateInput() -> Bool {
        if isTextFieldsFilled() {
            if FieldsValidator.isValidEmail(emailTextField.text!) {
                signUpButton.setTitle(ButtonTitle.signUp, for: .normal)
                signUpButton.alpha = 0.5
                activityIndicator.startAnimating()
                return true
            }
            showAlert(wit: "Wrong input", and:  "Invalid email")
            return false
        }
        showAlert(wit: "Wrong input", and:  "Please fill in all fields")
        return false
    }
    
    private func configure(textFiled: UITextField) {
        textFiled.delegate = self
        textFiled.addTarget(self, action: #selector(isTextFieldsFilled), for: .editingChanged)
    }
    
    @objc private func isTextFieldsFilled() -> Bool {
        if FieldsValidator.isFilledRegister(firstNameTF: firstNameTextField,
                            lastNameTF: lastNameTextField,
                            emailTF: emailTextField,
                            passwordTF: passwordTextField) {
            signUpButton.alpha = 1
            return true
        } else {
            signUpButton.alpha = 0.5
            return false
        }
    }
    
    @objc private func signUpPressed() {
        guard validateInput() else { return }
        firebaseManager.registerUser(firstName: firstNameTextField.text!,
                                     lastName: lastNameTextField.text!,
                                     email: emailTextField.text!,
                                     password: passwordTextField.text!,
                                     avatar: isImageChanged ? profileImageView.image : nil) { [weak self] result in
                                        guard let self = self else { return }
                                        switch result {
                                        case .success():
                                            self.showUserScreen(firebaseManager: self.firebaseManager)
                                        case .failure(let error):
                                            self.showAlert(
                                                wit: "Failed to create account",
                                                and: error.localizedDescription
                                            ) {
                                                self.signUpButton.setTitle(ButtonTitle.signUp,
                                                                            for: .normal)
                                                self.signUpButton.alpha = 1
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
    
    @objc private func openCamera(recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .recognized else { return }
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        camera.setValue(UIImage(systemName: "camera"), forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        let photo = UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.chooseImagePicker(source: .photoLibrary)
        })
        photo.setValue(UIImage(systemName: "photo"), forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        cancel.setValue(UIImage(systemName: "xmark"), forKey: "image")
        cancel.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        [camera, photo, cancel].forEach { actionSheet.addAction($0) }
        present(actionSheet, animated: true)
    }

}

    // MARK: - UITextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            signUpPressed()
        default:
            break
        }
        return true
    }
}

    // MARK: - Camera

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        } else {
            showAlert(wit: "Failed to take a shot",
                      and: "Camera is not available on this device")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage {
            profileImageView.image = image
        }
        picker.presentingViewController?.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true)
    }
}
