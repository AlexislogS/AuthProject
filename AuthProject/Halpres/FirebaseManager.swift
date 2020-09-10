//
//  FirebaseManager.swift
//  AuthProject
//
//  Created by Alex Yatsenko on 10.09.2020.
//  Copyright © 2020 AlexislogS. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

final class FirebaseManager {
    
    var isAuthorized: Bool {
        return userID != nil
    }
    
    private var userID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    func registerUser(firstName: String,
                      lastName: String,
                      email: String,
                      password: String,
                      avatar: UIImage?,
                      completion: @escaping (_ result: Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (creationResult, error) in
            if error != nil {
                completion(.failure(error!))
                return
            }
            let userID = creationResult!.user.uid
            if avatar != nil {
                self.uploadAvatar(image: avatar!, userID: userID) { url in
                    let user = User(firstName: firstName,
                                    lastName: lastName,
                                    avatarURL: url?.absoluteString)
                    Firestore.firestore().collection("users").document(userID).setData(user.convertToDictionary())
                    completion(.success(()))
                }
            } else {
                let user = User(firstName: firstName,
                                lastName: lastName,
                                avatarURL: nil)
                Firestore.firestore().collection("users").document(userID).setData(user.convertToDictionary())
                completion(.success(()))
            }
        }
    }
    
    func authorizeUser(by email: String,
                   and password: String,
                   completion: @escaping (_ result: Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                completion(.failure(error!))
                return
            }
            if result?.user != nil {
                completion(.success(()))
            }
        }
    }
    
    func unauthorizeUser(completion: @escaping (_ result: Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func fetchUser(completion: @escaping (_ result: Result<(user: User, avatar: UIImage?), Error>) -> Void) {
        guard userID != nil else { return }
        Firestore.firestore().collection("users").document(userID!).getDocument { (snapshot, error) in
            guard let snapshot = snapshot, snapshot.exists, let userData = snapshot.data() else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            let user = User(dictData: userData)
            if let avatarURL = user.avatarURL, !avatarURL.isEmpty {
                self.downloadAvatar(imageURL: avatarURL) { image in
                    completion(.success((user, image)))
                }
            } else {
                completion(.success((user, nil)))
            }
        }
    }
    
    private func uploadAvatar(image: UIImage,
                        userID: String,
                        completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let ref = Storage.storage().reference().child("avatars").child(userID)
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        ref.putData(imageData, metadata: metaData) { (resultMetaData, error) in
            guard error == nil else { return }
            ref.downloadURL { (url, error) in
                guard error == nil else { return }
                completion(url)
            }
        }
    }
    
    private func downloadAvatar(imageURL: String,
                                completion: @escaping (UIImage?) -> Void) {
        let ref = Storage.storage().reference(forURL: imageURL)
        let megaByte = Int64(1 * 1024 * 1024)
        ref.getData(maxSize: megaByte) { (data, error) in
            if let imageData = data {
                let image = UIImage(data: imageData)
                completion(image)
            }
        }
    }
}
