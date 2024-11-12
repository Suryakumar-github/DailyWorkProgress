//
//  IssueType.swift
//  HelpDeskManagement
//
//  Created by incubation on 08/11/24.
//

enum IssueType : String{
    case networkIisue
    case softwareIssue
    case hardwareIssue
    case securityIssue
    
    init?(status: String) {
        switch status.lowercased() {
        case "network":
            self = .networkIisue
        case "software":
            self = .softwareIssue
        case "hardware":
            self = .hardwareIssue
        case "security":
            self = .securityIssue
        default:
            return nil
        }
    }
}
