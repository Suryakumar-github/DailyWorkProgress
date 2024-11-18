//
//  TicketControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//

import Foundation

class TicketControllerImpl: TicketController {
    
    private weak var delegate: TicketAssignmentDelegate?
    private weak var agentController : AgentController?
    private weak var userController : UserController?
    lazy var userView = UserView()
    
    func setAgentController(agentController: AgentController) {
        self.agentController = agentController
    }
    
    func setUserController(userController: UserController) {
        self.userController = userController
    }
    
    func setDelagate(ticketAssignmentDelegate : TicketAssignmentDelegate) {
        self.delegate = ticketAssignmentDelegate
    }
    
    func createTicket(title ticketTitle: String, description ticketDescription: String, priority ticketPriority: Priority?, createdDate: Date, status: TicketStatus, agentId: Int?, userId: Int, issueType : IssueType) {
        let ticket = Ticket(title: ticketTitle, description: ticketDescription, priority: ticketPriority, createdDate: createdDate, status: status, userId: userId, issueType: issueType)
        
        prioritizeTicket(ticket: ticket, userId: ticket.getUserId)
        if ((delegate?.assignTicketToAgent(ticket: ticket)) != nil)  {
            print("Ticket Created and Assigned to Agent")
        }
        else {
            print("Ticket Created but Agent is Notavailable to Assign the Ticket")
        }
        DataStorage.allTickets[ticket.getTicketId] = ticket
        Logger.log(logType: LogType.info, message: "New Ticket Created with TicketId : \(ticket.getTicketId)", userId: ticket.getTicketId, data: ticket)
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
        Logger.log(logType: LogType.info, message: "Ticket status updated to \(status) for ticketId: \(ticketId) by agent.", userId: ticketId, data: ticket)
        return true
    }
    
    func closeTicket(agent: Agent, ticketId: Int) -> Bool {
        guard let ticketIndex = agent.assignedTicketsProperty.firstIndex(where: { $0.getTicketId == ticketId }) else {
                print("Agent does not have this ticket assigned. Cannot close ticket.")
                return false
            }
        
        guard agent.assignedTicketsProperty.contains(where: { $0.getTicketId == ticketId }) else {
            print("Agent does not have this ticket assigned. Cannot close ticket.")
            return false
        }
        
        guard let ticket = getTicketById(ticketId: ticketId) else {
            print("Ticket not found with ID: \(ticketId)")
            return false
        }
        
        if (ticket.statusProperty != TicketStatus.solved ){
            delegate?.resolveTicket(agent: agent, ticketId: ticketId, userId: ticket.getUserId)
        }
        Logger.log(logType: LogType.info, message: "Ticket Closed for ticketId: \(ticketId) by AgentId : \(agent.getId)", userId: ticket.getUserId, data: ticket)
        
        DataStorage.allTickets.removeValue(forKey: ticketId)
        agent.assignedTicketsProperty.remove(at: ticketIndex)
        print("Ticket with ID \(ticketId) has been successfully closed and removed.")
        
        return true
    }
    
    func cancelTicket (user : User, ticketId : Int) -> Bool {
        let tickets = userController?.getAllTheCreatedTickets(user: user)
        guard (tickets?.firstIndex(where: { $0.getTicketId == ticketId })) != nil else {
                print("User does not have this ticket assigned. Cannot close ticket.")
                return false
            }
        
        guard ((tickets?.contains(where: { $0.getTicketId == ticketId })) != nil) else {
            return false
        }
        
        guard let ticket = getTicketById(ticketId: ticketId) else {
            print("Ticket not found with ID: \(ticketId)")
            return false
        }
        
        if let assignedAgent = findAgentByTicketId(ticketId: ticketId) {
                
            assignedAgent.assignedTicketsProperty.removeAll { $0.getTicketId == ticketId }
        }
        
        Logger.log(logType: LogType.info, message: "Ticket canceld for ticketId: \(ticketId) by UserId : \(user.getUserId)", userId: ticketId, data: ticket)
        DataStorage.allTickets.removeValue(forKey: ticketId)
        print("Ticket cancelled ")
        
        return true
    }
    
    func findAgentByTicketId(ticketId: Int) -> Agent? {
        for (_,agent) in DataStorage.allAgents {
            if agent.assignedTicketsProperty.contains(where: { $0.getTicketId == ticketId }) {
                return agent
            }
        }
        return nil
    }
    
    func fetchAssignedTickets(agent: Agent) -> [Ticket] {
        return agent.assignedTicketsProperty
    }
    
    func prioritizeTicket(ticket: Ticket, userId: Int) {
        let user = userController?.getUserById(userId: userId)
        
        if user?.userRoleProperty == UserRole.vip{
            ticket.priorityProperty = Priority.high
            print("prioritised as high")
        }
        else if user?.userRoleProperty == UserRole.standard{
            ticket.priorityProperty = Priority.medium
            print("prioritised as mid")
        }
        else if user?.userRoleProperty == UserRole.guest{
            ticket.priorityProperty = Priority.low
            print("prioritised as low")
        }
    }
    
    func reassignTicket(ticketId: Int, agentId: Int, oldAgentid: Int) -> Bool {
        guard let oldAgent = agentController?.getAgentById(agentId: oldAgentid) else {
            print("No Agent available with oldAgentId: \(oldAgentid)")
            return false
        }
        guard let ticket = getTicketById(ticketId: ticketId) else {
            print("No Ticket available with ticketId: \(ticketId)")
            return false
        }
        guard let agent = agentController?.getAgentById(agentId: agentId) else {
            print("No Agent available with agentId: \(agentId)")
            return false
        }
        
        if let index = oldAgent.assignedTicketsProperty.firstIndex(where: { $0.getTicketId == ticketId }) {
            oldAgent.assignedTicketsProperty.remove(at: index)
            agent.assignedTicketsProperty.append(ticket)
            
            Logger.log(logType: LogType.info, message: "Ticket Reassigned From OldAgentId: \(oldAgentid) to NewAgentId: \(agentId)", userId: agentId, data: agent)
            return true
        } else {
            print("Old Agent does not have the specified ticket assigned.")
            return false
        }
    }

    func getTicketById(ticketId : Int) -> Ticket? {
        Logger.getItemById(from: DataStorage.allTickets, id: ticketId)
    }
    
    func getTicketByDate(date: Date) -> [Ticket] {
        let tickets = DataStorage.allTickets
        return tickets.compactMap { (_, ticket) in
            Calendar.current.isDate(ticket.getTicketCreatedDate, inSameDayAs: date) ? ticket : nil
        }
    }
}
