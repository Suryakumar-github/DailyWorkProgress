//
//  IssueType.swift
//  HelpDeskManagement
//
//  Created by incubation on 08/11/24.
//

enum IssueType : String{
    case network
    case software
    case hardware
    case security
    
    init?(status: String) {
        switch status.lowercased() {
        case "network":
            self = .network
        case "software":
            self = .software
        case "hardware":
            self = .hardware
        case "security":
            self = .security
        default:
            return nil
        }
    }
}
