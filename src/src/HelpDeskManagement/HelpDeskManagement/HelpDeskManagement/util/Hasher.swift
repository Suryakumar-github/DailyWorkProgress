//
//  Hasher.swift
//  HelpDeskManagement
//
//  Created by incubation on 18/11/24.
//

import Foundation
import CryptoKit

class StringHasher {

    static func hash(_ input: String) -> String {
        guard let data = input.data(using: .utf8) else {
            fatalError("Failed to convert input to Data.")
        }
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    static func verify(input: String, hash: String) -> Bool {
        return self.hash(input) == hash
    }
}

