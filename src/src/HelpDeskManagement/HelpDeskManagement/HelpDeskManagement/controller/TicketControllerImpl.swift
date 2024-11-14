//
//  TicketControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//

import Foundation

class TicketControllerImpl: TicketController {
    
    private weak var agentController : AgentController?
    private weak var userController : UserController?
    lazy var userView = UserView()
    
    func setAgentController(agentController: AgentController) {
        self.agentController = agentController
    }
    
    func setUserController(userController: UserController) {
        self.userController = userController
    }
    
    func createTicket(title ticketTitle: String, description ticketDescription: String, priority ticketPriority: Priority?, createdDate: Date, status: TicketStatus, agentId: Int?, userId: Int) {
        let ticket = Ticket(title: ticketTitle, description: ticketDescription, priority: ticketPriority, createdDate: createdDate, status: status, userId: userId)
        
        prioritizeTicket(ticketId: ticket.getTicketId, userId: ticket.getUserId)
        if ((agentController?.assignTicketToAgent(ticket: ticket)) != nil) {
            print("Ticket Created and Assigned to Agent")
        }
        else {
            print("Ticket Craetion is Failed ")
        }
        DataStorage.allTickets[ticket.getTicketId] = ticket
        let logsEntry = LogsEntry(timestamp: Date(), logType: LogType.info, message: "New Ticket Created with TicketId : \(ticket.getTicketId)", userId: ticket.getTicketId)
        DataStorage.allLogsEntry[logsEntry.getId] = logsEntry
    }
    
    func getUserIdByTicketId(ticketId: Int) -> Int? {
        let ticket = getTicketById(ticketId: ticketId)
        return ticket?.getUserId
    }
    
    func updateTicketStatus(agent: Agent, ticketId: Int, status: TicketStatus) -> Bool {
        guard agent.assignedTicketsProperty.contains(where: { $0.getTicketId == ticketId }) else {
            print("Agent does not have this ticket assigned. Cannot update status.")
            return false
        }

        guard let ticket = getTicketById(ticketId: ticketId) else {
            print("Ticket not found with ID: \(ticketId)")
            return false
        }
        ticket.statusProperty = status
        
        let logsEntry = LogsEntry(
            timestamp: Date(),
            logType: .info,
            message: "Ticket status updated to \(status) for ticketId: \(ticketId) by agent.",
            userId: ticketId
        )
        DataStorage.allLogsEntry[logsEntry.getId] = logsEntry
        print("Ticket status updated to \(status) for ticketId: \(ticketId).")

        return true
    }


    
    func closeTicket(agent: Agent, ticketId: Int) -> Bool {
        guard agent.assignedTicketsProperty.contains(where: { $0.getTicketId == ticketId }) else {
            print("Agent does not have this ticket assigned. Cannot close ticket.")
            return false
        }
        
        guard let ticket = getTicketById(ticketId: ticketId) else {
            print("Ticket not found with ID: \(ticketId)")
            return false
        }
        
        agentController?.resolveTicket(agent: agent, ticketId: ticketId, userId: ticket.getUserId)
        
        let logsEntry = LogsEntry(
            timestamp: Date(),
            logType: .info,
            message: "Ticket Closed for ticketId: \(ticketId)",
            userId: ticket.getUserId
        )
        DataStorage.allLogsEntry[logsEntry.getId] = logsEntry
        
        DataStorage.allTickets.removeValue(forKey: ticketId)
        print("Ticket with ID \(ticketId) has been successfully closed and removed.")
        
        return true
    }

    
    func fetchAssignedTickets(agent: Agent) -> [Ticket] {
        return agent.assignedTicketsProperty
    }
    
    func prioritizeTicket(ticketId: Int, userId: Int) {
        let user = userController?.getUserById(userId: userId)
        let ticket = getTicketById(ticketId: ticketId)
        
        if user?.userRoleProperty == UserRole.vip{
            ticket?.priorityProperty = Priority.high
            print("prioritised as high")
        }
        else if user?.userRoleProperty == UserRole.standard{
            ticket?.priorityProperty = Priority.medium
            print("prioritised as mid")
        }
        else if user?.userRoleProperty == UserRole.guest{
            ticket?.priorityProperty = Priority.low
            print("prioritised as low")
        }
       
    }
    
    func reassignTicket(ticketId: Int, agentId : Int, oldAgentid : Int) -> Bool {
        let oldAgent = agentController?.getAgentById(agentId: oldAgentid)
        let ticket = getTicketById(ticketId: ticketId)!
        let agent = agentController?.getAgentById(agentId: agentId)
        agent?.assignedTicketsProperty.append(ticket)
        oldAgent?.assignedTicketsProperty.remove(at: ticketId)
        let logsEntry = LogsEntry(timestamp: Date(), logType: LogType.info, message: "Ticket Reassigned From OldAgentId : \(oldAgentid) to NewAgentId : \(agentId)", userId: agentId)
        DataStorage.allLogsEntry[logsEntry.getId] = logsEntry
        return true
    }
    
    func getTicketById(ticketId : Int) -> Ticket? {
        let tickets = DataStorage.allTickets
        
        if let ticket = tickets[ticketId] {
            return ticket
        }
        return nil
    }
    
    func getTicketByDate(date: Date) -> [Ticket] {
        let tickets = DataStorage.allTickets
        return tickets.compactMap { (_, ticket) in
            Calendar.current.isDate(ticket.getTicketCreatedDate, inSameDayAs: date) ? ticket : nil
        }
    }
}
