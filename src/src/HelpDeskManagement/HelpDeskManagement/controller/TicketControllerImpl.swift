//
//  TicketControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//

import Foundation

class TicketControllerImpl: TicketController {

    private var agentController : AgentController?
    private var userController : UserController?
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
    
    func updateTicketStatus(ticketId: Int, status: TicketStatus) -> Bool {
        if let ticket = getTicketById(ticketId: ticketId) {
            ticket.statusProperty = status
            let logsEntry = LogsEntry(timestamp: Date(), logType: LogType.info, message: "Ticket Status Update for tickedId : \(ticketId) as \(status)", userId: ticketId)
            DataStorage.allLogsEntry[logsEntry.getId] = logsEntry
            return true
        }
        return false
    }
    
    func closeTicket(ticketId: Int) -> Bool {
        let ticket = getTicketById(ticketId: ticketId)
        agentController?.resolveTicket(ticketId: ticketId, userId: ticket!.getUserId)
        let logsEntry = LogsEntry(timestamp: Date(), logType: LogType.info, message: "Ticket Closed for ticketId : \(ticketId)", userId: ticketId)
        DataStorage.allLogsEntry[logsEntry.getId] = logsEntry
        return true
    }
    
    func fetchAssignedTickets(agentId: Int) -> [Ticket] {
        let agent = agentController?.getAgentById(agentId: agentId)
        print("agent is ...\(String(describing: agent?.getName))")
        return agent!.assignedTicketsProperty
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
