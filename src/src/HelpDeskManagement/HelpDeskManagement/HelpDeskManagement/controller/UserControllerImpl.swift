//
//  UserControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//

import Foundation

class UserControllerImpl : UserController {
    
    private weak var ticketController : TicketController?
    
    func setTicketController(ticketController: any TicketController) {
        self.ticketController = ticketController
    }
    
    func register(name : String, userRole : UserRole, userName : String, password : String) -> User {
        let user = User(name: name, userRole: userRole, userName: userName, password: password, role : Role.user)
        DataStorage.allUsers[user.getUserId] = user
        Logger.log(logType: LogType.info, message: "New User Registered", userId: user.getUserId, data: user)
        return user
    }
    
    func changePassword(user : User, password : String) -> Bool {
        let hashedPassword = StringHasher.hash(password)
        if user.passwordProperty == hashedPassword {
            return false
        }
        user.passwordProperty = hashedPassword
        return true
    }
    
    func viewTicketStatus(ticketid: Int) -> TicketStatus {
        let ticket = ticketController?.getTicketById(ticketId: ticketid)
        return ticket!.statusProperty
    }
    
    func getUserById(userId: Int) -> User? {
        return Logger.getItemById(from: DataStorage.allUsers, id: userId)
    }

    func getAllTheCreatedTickets(user: User) -> [Ticket] {
        var tickets : [Ticket] = []
        
        let allTickets = DataStorage.allTickets
        
        for (_,ticket) in allTickets {
            if ticket.getUserId == user.getUserId {
                tickets.append(ticket)
            }
        }
        return tickets
    }
    
    func notifyUser(ticket: Int, description: String, user: inout User) -> Bool {
        user.userNotificationsProperty[ticket] = description
        return true
    }
    
    private var users = [
            ["SuperAdmin", "SuperAdmin@123", "Admin"]
        ]
    
    func authenticate(username: String, password: String, role: Role) -> AnyObject? {
        switch role {
        case .admin:
            return authenticateAdmin(username: username, password: password)
        case .agent:
            return authenticateAgent(username: username, password: password)
        case .user:
            return authenticateUser(username: username, password: password)
        }
    }
            
    private func authenticateAdmin(username: String, password: String) -> User? {
        guard users.contains(where: { $0[0].lowercased() == username.lowercased() && $0[1] == password && $0[2].lowercased() == Role.admin.rawValue.lowercased() }) else {
            print("Login failed: Invalid admin credentials.")
            return nil
        }
        let admin = User(name: "admin", userRole: UserRole.admin, userName: username, password: password, role: Role.admin)
        return admin
    }
      
    private func authenticateAgent(username: String, password: String) -> Agent? {
        let hashedUsername = StringHasher.hash(username)
        let hashedPassword = StringHasher.hash(password)

        guard let agent = DataStorage.allAgents.values.first(where: {
            $0.getUserName == hashedUsername && $0.passwordproperty == hashedPassword
        }) else {
            print("Login failed: Invalid Agent credentials.")
            return nil
        }

        return agent
    }
    
    private func authenticateUser(username: String, password: String) -> User? {
        let hashedUsername = StringHasher.hash(username)
        let hashedPassword = StringHasher.hash(password)
        
        guard let user1 = DataStorage.allUsers.values.first(where: {
            $0.getUserName == hashedUsername && $0.passwordProperty == hashedPassword
            
        }) else {
            print("Login failed: Invalid User credentials.")
            return nil
        }
        return getUserByUserNameAndPassword(username: username, password: password)
    }
    
    func getUserNotifications(userId : Int) -> [Int: String] {
        guard let user = getUserById(userId: userId) else {
            print("User with ID \(userId) not found.")
            return [:]
        }
        let notifications = user.userNotificationsProperty
        return notifications
    }
    
    private func getUserByUserNameAndPassword(username : String, password: String) -> User? {
        let users = DataStorage.allUsers
        
        for (_,user) in users {
            if user.getUserName == username && user.passwordProperty == password {
                return user
            }
        }
        return nil
    }
    
    private func getAgentByUserNameAndPassword(username : String, password: String) -> Agent? {
        let agenst = DataStorage.allAgents
        
        for (_,agent) in agenst {
            if agent.getUserName == username && agent.passwordproperty == password {
                return agent
            }
        }
        return nil
    }
    deinit{
        
    }
}
