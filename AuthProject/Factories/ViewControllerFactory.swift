//
//  ViewControllerFactory.swift
//  AuthProject
//
//  Created by Alex Yatsenko on 10.09.2020.
//  Copyright © 2020 AlexislogS. All rights reserved.
//

protocol ViewControllerFactory {
    func makeAuthVC() -> AuthViewController
    func makeLoginVC() -> LoginViewController
    func makeSignupVC() -> RegisterViewController
    func makeUserVC() -> UserViewController
}

final class ViewControllerFactoryImpl {
    lazy var firebaseManager = FirebaseManager()
}

extension ViewControllerFactoryImpl: ViewControllerFactory {
    
    func makeAuthVC() -> AuthViewController {
        return AuthViewController()
    }
    
    func makeLoginVC() -> LoginViewController {
        return LoginViewController(firebaseManager: firebaseManager)
    }
    
    func makeSignupVC() -> RegisterViewController {
        return RegisterViewController(firebaseManager: firebaseManager)
    }
    
    func makeUserVC() -> UserViewController {
        return UserViewController(firebaseManager: firebaseManager)
    }
}
