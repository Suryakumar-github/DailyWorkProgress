//
//  TicketController.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//
import Foundation

protocol TicketController {
    func createTicket (title : String, description : String, priority : Priority?, createdDate : Date, status : TicketStatus, agentId : Int?, userId : Int) 
    func updateTicketStatus (ticketId : Int, status : TicketStatus) -> Bool
    func closeTicket (ticketId : Int) -> Bool
    func fetchAssignedTickets(agentId : Int) -> [Ticket]
    func prioritizeTicket(ticketId : Int, userId : Int)
    func reassignTicket(ticketId : Int, agentId : Int) -> Bool
    func getTicketById(ticketId: Int) -> Ticket?
    func setAgentController(agentController : AgentController)
    func setUserController(userController : UserController)
    func getTicketByDate(date: Date) -> [Ticket]
}
