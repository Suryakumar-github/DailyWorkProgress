//
//  DataBaseError.swift
//  HelpDeskManagement
//
//  Created by incubation on 26/11/24.
//

enum DatabaseError: Error {
    case tableCreationFailed(String)
    case preparationFailed(String)
    case executionFailed(String)
    case noRecordFound(String)
}
