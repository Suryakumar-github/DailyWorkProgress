//
//  UserController.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//

import Foundation

protocol UserController : AnyObject {
    func register(name : String, userRole : UserRole, userName : String, password : String)  throws -> User?
    func viewTicketStatus(ticketid : Int)   throws -> TicketStatus
    func getUserById(userId : Int)   throws -> User?
    func authenticate(username: String, password: String)   throws -> AnyObject?
    func setTicketController(ticketController : TicketController)
    func setKnowledgeBaseController(knowledgeBaseController : KnowledgeBaseControllerImpl)
    func getAllTheCreatedTickets(user: User)   throws-> [Ticket]
    func changePassword(user : User, password : String, currentPassword : String)   throws -> Bool
    func createTicket (title : String, description : String, createdDate : Date, status : TicketStatus, userId : Int, issueType : IssueType)  throws
    func cancelTicket (user : User, ticketId : Int)   throws-> Bool
    func search(word: String)  throws -> [KnowledgeBase]
    func getAllKnowledgeBaseEntries()   throws -> [KnowledgeBase]
    func setLogsEntryController(logsEntryController: LogsEntryController)
}
