//
//  User.swift
//  HelpDeskManagement
//
//  Created by incubation on 04/11/24.
//

class User {
    
    private let id : Int
    private let name : String
    private var userRole : UserRole?
    private var role : Role
    
    init(userId : Int, name: String, userRole: UserRole? = nil, role : Role) {
        self.id = userId
        self.name = name
        self.userRole = userRole
        self.role = role
    }
    init(id : Int, name : String,role : Role) {
        self.id = id
        self.name = name
        self.role = role
    }
    
    var getId : Int {
        return id
    }
        
    var getName : String {
        return name
    }
    
    var getRole : Role {
        return role
    }
    
    var userRoleProperty : UserRole? {
        get {
            return userRole
        }
        set(newRole) {
            userRole = newRole
        }
    }
    
    deinit{
        
    }
}

extension User: Loggable {
    var logType: LogType {
        return .info
    }
    
    var logMessage: String {
        return ""
    }
    
    var logId : Int {
        return self.getId
    }
}

extension User: Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
