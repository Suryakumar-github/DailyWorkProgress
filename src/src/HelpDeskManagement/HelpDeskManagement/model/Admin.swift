//
//  Admin.swift
//  HelpDeskManagement
//
//  Created by incubation on 22/11/24.
//

class Admin : User {
    private var hasDefaultPassword : Bool
    private var userId : Int
    
    init(name: String, userRole: UserRole? = nil, role : Role, userId : Int, hasDefaultPassword : Bool) {
        self.hasDefaultPassword = hasDefaultPassword
        self.userId = userId
        super.init(userId: userId, name: name, userRole: UserRole.admin, role: Role.admin)
    }
        
    var isDefaultPassword : Bool {
        get {
            return hasDefaultPassword
        }
        set(newDefaultPassword) {
            hasDefaultPassword = newDefaultPassword
        }
    }
    var getUserId : Int {
        return userId
    }
}
