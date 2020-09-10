//
//  UserViewController.swift
//  AuthProject
//
//  Created by Alex Yatsenko on 10.09.2020.
//  Copyright © 2020 AlexislogS. All rights reserved.
//

import UIKit

final class UserViewController: UIViewController, SignScreenFactory {
    
    private let firebaseManager: FirebaseManager
    
    private var isImageChanged: Bool {
        return profileImageView.image != Image.placeholder
    }
    private lazy var headLabel: UILabel = {
        let label = makeLabel(with: "Welcome", and: 40)
        return label
    }()
    private lazy var profileImageView: UIImageView = {
        let imageView = makeImageView()
        return imageView
    }()
    private lazy var logOutButton: UIButton = {
        let button = makeButton(with: "Log Out")
        button.addTarget(self, action: #selector(logOutPressed), for: .touchUpInside)
        return button
    }()
    
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
        navigationController?.isNavigationBarHidden = true
        [headLabel, profileImageView, logOutButton].forEach { view.addSubview($0) }
        constraintSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIWithData()
    }
    
    private func constraintSubviews() {
        profileImageView.anchors(top: view.safeAreaLayoutGuide.topAnchor,
                                 centerX: view.centerXAnchor,
                                 padding: .init(top: 13, left: 0, bottom: 0, right: 0))
        profileImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        logOutButton.anchors(leading: view.safeAreaLayoutGuide.leadingAnchor,
                             trailing: view.safeAreaLayoutGuide.trailingAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor, padding: .init(top: 0, left: 100, bottom: 100, right: 100))
        
        headLabel.anchors(centerX: view.centerXAnchor, centerY: view.centerYAnchor)
    }
    
    private func showAuthScreen() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        let vcFactory = sceneDelegate.vcFactory
        let authVC = UINavigationController(rootViewController: vcFactory.makeAuthVC())
        sceneDelegate.window?.rootViewController = authVC
        sceneDelegate.window?.makeKeyAndVisible()
    }
    
    private func updateUIWithData() {
        firebaseManager.fetchUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let resultData):
                self.headLabel.text = resultData.user.firstName
                if let image = resultData.avatar {
                    self.profileImageView.image = image
                } else if self.isImageChanged {
                    self.profileImageView.image = Image.placeholder
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func logOutPressed() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            self.firebaseManager.unauthorizeUser { [ weak self] result in
                switch result {
                case .success():
                    self?.showAuthScreen()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true)
    }
}
