//
//  UserControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//

class UserControllerImpl : UserController {
    
    var ticketController : TicketController?
    
    func setTicketController(ticketController: any TicketController) {
        self.ticketController = ticketController
    }
    
    func register(name : String, userRole : UserRole, userName : String, password : String) {
        let user = User(name: name, role: userRole, userName: userName, password: password)
        var users = DataStorage.allUsers
        users[user.getUserId] = user
        DataStorage.allUsers = users
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
    
    var users = [
        ["SuperAdmin", "SuperAdmin@123", "Admin"]
    ]

    func authenticate(username: String, password: String, role: Role) -> Bool {
        if let user = users.first(where: {
            $0[0] == username && $0[1] == password && $0[2].lowercased() == role.rawValue.lowercased()
        }) {
            print("Login successful for \(role) \(user[0])")
            return true
        } else {
            print("Login failed: Invalid credentials or role.")
            return false
        }
    }
}
