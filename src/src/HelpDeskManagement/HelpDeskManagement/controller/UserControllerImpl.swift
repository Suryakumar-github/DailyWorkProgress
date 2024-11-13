//
//  UserControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//

import Foundation

class UserControllerImpl : UserController {
    
    var ticketController : TicketController?
    
    func setTicketController(ticketController: any TicketController) {
        self.ticketController = ticketController
    }
    
    func register(name : String, userRole : UserRole, userName : String, password : String) -> Int {
        let user = User(name: name, role: userRole, userName: userName, password: password)
        DataStorage.allUsers[user.getUserId] = user
        let logsEntry = LogsEntry(timestamp: Date(), logType: LogType.info, message: "New User Registered", userId: user.getUserId)
        DataStorage.allLogsEntry[logsEntry.getId] = logsEntry
        return user.getUserId
    }
    
    func viewTicketStatus(ticketid: Int) -> TicketStatus {
        let ticket = ticketController?.getTicketById(ticketId: ticketid)
        return ticket!.statusProperty
    }
    
    func getUserById(userId: Int) -> User? {
        let users = DataStorage.allUsers
        if let user = users[userId] {
            return user
        }
        return nil
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
        
    func authenticate(username: String, password: String, role: Role) -> Bool {
        switch role {
        case .admin:
            return authenticateAdmin(username: username, password: password)
        case .agent:
            return authenticateAgent(username: username, password: password)
        default:
            print("Role not supported for authentication.")
            return false
        }
    }
        
    private func authenticateAdmin(username: String, password: String) -> Bool {
        return users.contains(where: {
            $0[0].lowercased() == username.lowercased() &&
            $0[1] == password &&
            $0[2].lowercased() == Role.admin.rawValue.lowercased()
        })
    }
        
        private func authenticateAgent(username: String, password: String) -> Bool {
            guard let agent = DataStorage.allAgents.values.first(where: { agent in
                agent.getUserName == username && agent.passwordproperty == password
            }) else {
                print("Login failed: Invalid Agent credentials.")
                return false
            }
            print("Login successful for Agent \(agent.getName)")
            return true
        }
    
    func getUserNotifications(userId : Int) -> [Int: String] {
        guard let user = getUserById(userId: userId) else {
            print("User with ID \(userId) not found.")
            return [:]
        }
        let notifications = user.userNotificationsProperty
        return notifications
    }
}
