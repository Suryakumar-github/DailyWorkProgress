//
//  User.swift
//  HelpDeskManagement
//
//  Created by incubation on 04/11/24.
//

class User {
    
    private let id : Int
    private let name : String
    private var userRole : UserRole
    private var role : Role
    private var userNotifications : [Int : String] = [:]
    private let userName : String
    private var password : String
    private static var userCount = 0
    
    init(name: String, userRole: UserRole, userName : String, password : String, role : Role) {
        User.userCount += 1
        self.id = User.userCount
        self.name = name
        self.userRole = userRole
        self.password = StringHasher.hash(password)
        self.userName = StringHasher.hash(userName)
        self.role = role
    }
    
    var getUserId : Int {
        return id
    }
    
    var getUserName : String {
        return userName
    }
    
    var getName : String {
        return name
    }
    
    var passwordProperty : String {
        get {
            return password
        }
        set(newPassword) {
            password = newPassword
        }
    }
    
    var userRoleProperty : UserRole {
        get {
            return userRole
        }
        set(newRole) {
            userRole = newRole
        }
    }
    
    var userNotificationsProperty : [Int : String] {
        get {
            return userNotifications
        }
        set(newNotification) {
            userNotifications = newNotification
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
        return self.getUserId
    }
}
