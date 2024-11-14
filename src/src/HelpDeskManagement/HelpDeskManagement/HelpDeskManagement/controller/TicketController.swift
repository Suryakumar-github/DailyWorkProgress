//
//  TicketController.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//
import Foundation

protocol TicketController : AnyObject{
    func createTicket (title : String, description : String, priority : Priority?, createdDate : Date, status : TicketStatus, agentId : Int?, userId : Int) 
    func updateTicketStatus (agent : Agent, ticketId : Int, status : TicketStatus) -> Bool
    func closeTicket (agent : Agent, ticketId : Int) -> Bool
    func cancelTicket (user : User, ticketId : Int) -> Bool
    func fetchAssignedTickets(agent : Agent) -> [Ticket]
    func prioritizeTicket(ticket : Ticket, userId : Int)
    func reassignTicket(ticketId: Int, agentId : Int, oldAgentid : Int) -> Bool
    func getTicketById(ticketId: Int) -> Ticket?
    func setAgentController(agentController : AgentController)
    func setUserController(userController : UserController)
    func setDelagate(ticketAssignmentDelegate : TicketAssignmentDelegate)
    func getTicketByDate(date: Date) -> [Ticket]
    func getUserIdByTicketId(ticketId: Int) -> Int?
}
