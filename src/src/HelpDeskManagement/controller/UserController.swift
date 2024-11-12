//
//  UserController.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//

protocol UserController {
    func register(name : String, userRole : UserRole, userName : String, password : String)
    func viewTicketStatus(ticketid : Int) -> TicketStatus
    func getUserById(userId : Int) -> User?
    func notifyUser(ticket: Int, description: String, user: inout User) -> Bool
    func authenticate(username: String, password: String, role: Role) -> Bool
    func setTicketController(ticketController : TicketController)
    func getAllTheCreatedTickets(user: User) -> [Ticket]
}
