//
//  Role.swift
//  HelpDeskManagement
//
//  Created by incubation on 11/11/24.
//

enum Role: String {
    case admin
    case agent
    case user
    
    init?(role: String) {
        switch role.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
        case "admin":
            self = .admin
        case "agent":
            self = .agent
        case "user":
            self = .user
        default:
            return nil
        }
    }
}
