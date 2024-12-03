//
//  TicketController.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//
import Foundation

protocol TicketController : AnyObject{
    func createTicket (title : String, description : String, createdDate : Date, status : TicketStatus, userId : Int, issueType : IssueType) throws
    func updateTicketStatus (agent : Agent, ticketId : Int, status : TicketStatus) throws -> Bool
    func closeTicket (agent : Agent, ticketId : Int) throws -> Bool
    func cancelTicket (user : User, ticketId : Int) throws -> Bool
    func fetchAssignedTickets(agent : Agent)throws -> [Ticket]
    func prioritizeTicket(ticket : Ticket, userId : Int)throws
    func reassignTicket(ticketId: Int, agentId : Int)throws -> Bool
    func getTicketById(ticketId: Int)throws -> Ticket?
    func setAgentController(agentController : AgentController)
    func setUserController(userController : UserController)
    func setDelagate(ticketAssignmentDelegate : TicketAssignmentDelegate)
    func getTicketByDate(date: Date)throws -> [Ticket]
    func getUserIdByTicketId(ticketId: Int)throws -> Int?
    func getAgentIdByTicketId(ticketId: Int)throws -> Int?
    func getAllTheCreatedTickets(user: User)throws -> [Ticket]
    func getAllCreatedTickets()throws -> [Ticket]
    func getTicketsBetweendates(date1 : Date, date2 : Date) throws -> [Ticket]
}
