//
//  TicketDAO.swift
//  HelpDeskManagement
//
//  Created by incubation on 26/11/24.
//

import Foundation

protocol TicketDAO
{
    func addTicket(ticket: Ticket)  -> Result<Void, DatabaseError>
    func getAllTheCreatedTickets(user: User)  -> Result<[Ticket], DatabaseError>
    func updateTicketStatus(ticketId: Int, status: TicketStatus)  -> Result<Void, DatabaseError>
    func findAgentByTicketId(ticketId: Int)  -> Result<Agent?, DatabaseError>
    func fetchAssignedTickets(agent: Agent)  -> Result<[Ticket], DatabaseError>
    func getTicketById(ticketId: Int)  -> Result<Ticket?, DatabaseError>
    func getTicketByDate(date: Date) throws -> Result<[Ticket], DatabaseError>
    func removeTicket(agentId : Int, ticketId : Int)  -> Result<Void, DatabaseError>
    func getAllTickets()  throws -> Result<[Ticket], DatabaseError>
    func updatePriority(ticketId: Int, newPriority: Int)  -> Result<Void, DatabaseError>
    func getLastCreatedTicketId()  throws -> Result<Int, DatabaseError>
    func getTicketsBetweendates(date1 : Date, date2 : Date)  throws -> Result<[Ticket], DatabaseError>
    func getUnassignedTickets()  throws -> Result<[Ticket],DatabaseError>
}
