//
//  Validation.swift
//  HelpDeskManagement
//
//  Created by incubation on 12/11/24.
//

import Foundation

struct Validation {

    private init() { }
    
    private static let PASSWORD_REGEX = #"^[a-zA-Z](?=.*[@#$%^&+=])(?=\S+$).{5,9}$"#
    private static let NAME_REGEX = #"^[a-zA-Z]+$"#
    private static let USERNAME_REGEX = #"^[a-zA-Z][a-zA-Z0-9]*$"#

    static func validatePassword(_ password: String) -> Bool {
        return validatePattern(password, regex: PASSWORD_REGEX)
    }

    static func validateName(_ name: String) -> Bool {
        return validatePattern(name, regex: NAME_REGEX)
    }

    static func validateUsername(_ username: String) -> Bool {
        return validatePattern(username, regex: USERNAME_REGEX)
    }

    private static func validatePattern(_ input: String, regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: input)
    }
}
