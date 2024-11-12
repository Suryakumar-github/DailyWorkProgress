//
//  Priority.swift
//  HelpDeskManagement
//
//  Created by incubation on 05/11/24.
//

enum Priority: Int, Comparable {
    case high = 3
    case medium = 2
    case low = 1
    
    static func < (lhs: Priority, rhs: Priority) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
