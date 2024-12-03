//
//  TicketAssigmentDelegate.swift
//  HelpDeskManagement
//
//  Created by incubation on 14/11/24.
//

protocol TicketAssignmentDelegate: AnyObject {
    func assignTicketToAgent(ticket: Ticket) throws -> Bool
    func resolveTicket(agent : Agent, ticketId : Int)throws
}
