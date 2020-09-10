//
//  User.swift
//  AuthProject
//
//  Created by Alex Yatsenko on 10.09.2020.
//  Copyright © 2020 AlexislogS. All rights reserved.
//

struct User {
    
    let firstName: String?
    let lastName: String?
    let avatarURL: String?
    
    init(firstName: String?, lastName: String?, avatarURL: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.avatarURL = avatarURL
    }
    
    init(dictData: [String : Any]) {
        firstName = dictData["firstName"] as? String
        lastName = dictData["lastName"] as? String
        avatarURL = dictData["avatarURL"] as? String
    }
    
    func convertToDictionary() -> [String : Any] {
        return ["firstName" : firstName ?? "",
                "lastName" : lastName ?? "",
                "avatarURL" : avatarURL ?? ""
        ]
    }
}
