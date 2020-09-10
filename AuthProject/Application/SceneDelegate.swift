//
//  SceneDelegate.swift
//  AuthProject
//
//  Created by Alex Yatsenko on 10.09.2020.
//  Copyright © 2020 AlexislogS. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    let vcFactory = ViewControllerFactoryImpl()
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        if vcFactory.firebaseManager.isAuthorized {
            window?.rootViewController = UINavigationController(rootViewController: vcFactory.makeUserVC())
        } else {
            window?.rootViewController = UINavigationController(rootViewController: vcFactory.makeAuthVC())
        }
        window?.tintColor = .label
        window?.makeKeyAndVisible()
    }
}
