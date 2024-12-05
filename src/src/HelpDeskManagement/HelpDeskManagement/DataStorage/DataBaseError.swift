//
//  DataBaseError.swift
//  HelpDeskManagement
//
//  Created by incubation on 26/11/24.
//

import Foundation

enum DatabaseError: Error {
    case tableCreationFailed(String)
    case preparationFailed(String)
    case executionFailed(String)
    case noRecordFound(String)
    case finalizationFailed(String)
}

extension DatabaseError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .tableCreationFailed(let message),
             .preparationFailed(let message),
             .executionFailed(let message),
             .finalizationFailed(let message),
             .noRecordFound(let message):
            return message
        }
    }
}
