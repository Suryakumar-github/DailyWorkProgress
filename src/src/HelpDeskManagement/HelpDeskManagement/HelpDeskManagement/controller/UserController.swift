//
//  UserController.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//

protocol UserController : AnyObject {
    func register(name : String, userRole : UserRole, userName : String, password : String) -> User
    func viewTicketStatus(ticketid : Int) -> TicketStatus
    func getUserById(userId : Int) -> User?
    func notifyUser(ticket: Int, description: String, user: inout User) -> Bool
    func authenticate(username: String, password: String, role: Role) -> AnyObject?
    func setTicketController(ticketController : TicketController)
    func getAllTheCreatedTickets(user: User) -> [Ticket]
    func getUserNotifications(userId : Int) -> [Int: String]
}
