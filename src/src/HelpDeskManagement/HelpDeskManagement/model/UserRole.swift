//
//  Role.swift
//  HelpDeskManagement
//
//  Created by incubation on 04/11/24.
//

enum UserRole : String{
    case admin
    case vip
    case standard
    case guest
    
    init?(role : String) {
        switch role.lowercased() {
        case "admin" :
            self = .admin
            
        case "vip" :
            self = .vip
            
        case "standard" :
            self = .standard
            
        case "guest" :
            self = .guest
            
        default :
            self = .guest
        }

    }
}
