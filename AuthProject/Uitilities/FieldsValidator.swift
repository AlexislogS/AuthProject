//
//  FieldsValidator.swift
//  AuthProject
//
//  Created by Alex Yatsenko on 10.09.2020.
//  Copyright © 2020 AlexislogS. All rights reserved.
//

import UIKit

struct FieldsValidator {
    
    static func isFilledRegister(firstNameTF: UITextField,
                                 lastNameTF: UITextField,
                                 emailTF: UITextField,
                                 passwordTF: UITextField) -> Bool {
        guard firstNameTF.hasText, lastNameTF.hasText,
            emailTF.hasText, passwordTF.hasText else { return false }
        if !(firstNameTF.text!.trimmingCharacters(in: .whitespaces)).isEmpty,
            !(lastNameTF.text!.trimmingCharacters(in: .whitespaces)).isEmpty,
            !(emailTF.text!.trimmingCharacters(in: .whitespaces)).isEmpty,
            !(passwordTF.text!.trimmingCharacters(in: .whitespaces)).isEmpty {
            return true
        }
        return false
    }
    
    static func isFilledLogin(emailTF: UITextField, passwordTF: UITextField) -> Bool {
        guard emailTF.hasText, passwordTF.hasText else { return false }
        if !(emailTF.text!.trimmingCharacters(in: .whitespaces)).isEmpty,
            !(passwordTF.text!.trimmingCharacters(in: .whitespaces)).isEmpty {
            return true
        }
        return false
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
}
