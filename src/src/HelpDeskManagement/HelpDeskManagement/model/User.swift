//
//  User.swift
//  HelpDeskManagement
//
//  Created by incubation on 04/11/24.
//

struct User {
    
    private let id : Int
    private let name : String
    private var role : UserRole
    private var userNotifications : [Int : String]? = [:]
    private let userName : String
    private var password : String
    private static var userCount = 0
    
    init(name: String, role: UserRole, userName : String, password : String) {
        User.userCount += 1
        self.id = User.userCount
        self.name = name
        self.role = role
        self.password = password
        self.userName = userName
    }
    
    var getUserId : Int {
        return id
    }
    
    var getUserName : String {
        return name
    }
    
    var userRoleProperty : UserRole {
        get {
            return role
        }
        set(newRole) {
            role = newRole
        }
    }
    
    var userNotificationsProperty : [Int : String] {
        get {
            return userNotifications ?? [:]
        }
        set(newNotification) {
            userNotifications = newNotification
        }
    }
}
