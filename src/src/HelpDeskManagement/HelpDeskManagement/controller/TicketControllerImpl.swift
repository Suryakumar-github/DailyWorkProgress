//
//  TicketControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//

import Foundation

class TicketControllerImpl: TicketController {
    
    private weak var delegate: TicketAssignmentDelegate?
    private var agentController : AgentController?
    private var userController : UserController?
    private var knowleggeBaseController : KnowledgeBaseController?
    private var logsEntryController : LogsEntryController?
    private var dataBase : DataBase
    private var ticketDao : TicketDAO
    lazy var userView = UserView()
    init(dateBase : DataBase) {
        self.dataBase = dateBase
        self.ticketDao = TicketDAOImpl(dataBase: dateBase)
    }
    
    func setAgentController(agentController: AgentController) {
        self.agentController = agentController
    }
    
    func setLogsEntryController(logsEntryController: LogsEntryController) {
        self.logsEntryController = logsEntryController
    }
    
    func setKnowledgeBaseController(knowledgeBaseController: KnowledgeBaseController) {
        self.knowleggeBaseController = knowledgeBaseController
    }
    
    func setUserController(userController: UserController) {
        self.userController = userController
    }
    
    func setDelagate(ticketAssignmentDelegate : TicketAssignmentDelegate) {
        self.delegate = ticketAssignmentDelegate
    }
    
    func createTicket(title ticketTitle: String, description ticketDescription: String, createdDate: Date, status: TicketStatus, userId: Int, issueType : IssueType) throws
    {
        let id : Int
        let ticketId = try ticketDao.getLastCreatedTicketId()
        switch ticketId {
        case .success(let newId) :
            id = newId + 1
        case .failure(let error) :
            throw error
        }
        
        let ticket = Ticket(id: id, title: ticketTitle, description: ticketDescription, createdDate: createdDate, status: status, userId: userId, issueType: issueType)
        
        try prioritizeTicket(ticket: ticket, userId: ticket.getUserId)
        let result = ticketDao.addTicket(ticket: ticket)
        switch result {
        case .success() :
            try logsEntryController?.log(logType: LogType.info, message: "New Ticket Created with TicketId : \(ticket.getTicketId)", userId: ticket.getTicketId, data: ticket)
        case .failure(let error) :
            throw error
        }
        guard let delegateCall = delegate else {
            print("Delegate Controller is Nil. Cannot Procede Furthere")
            return
        }
        if (try delegateCall.assignTicketToAgent(ticket: ticket)) {
            ticketDao.updateTicketStatus(ticketId: ticket.getTicketId, status: TicketStatus.assigned)
            print("Ticket Created and Assigned to Agent")
        }
        else {
            print("Ticket Created but Agent is Notavailable to Assign the Ticket")
        }
    }
    
    func fetchAssignedTickets(agent: Agent)throws -> [Ticket] {
        let result = ticketDao.fetchAssignedTickets(agent: agent)
        switch result {
        case .success(let tickets) :
            return tickets
        case .failure(let error) :
            throw error
        }
    }
    
    func getAllTheCreatedTickets(user: User) throws -> [Ticket] {
        let result = ticketDao.getAllTheCreatedTickets(user: user)
        switch result {
        case .success(let tickets) :
            return tickets
        case .failure(let error) :
            throw error
        }
    }
    
    func getUserIdByTicketId(ticketId: Int) throws -> Int? {
        let ticket = try getTicketById(ticketId: ticketId)
        return ticket?.getUserId
    }
    
    func getAgentIdByTicketId(ticketId: Int) throws -> Int? {
        guard let ticket = try getTicketById(ticketId: ticketId) else {
            return nil
        }
        return ticket.getAgentId
    }
    
    func updateTicketStatus(agent: Agent, ticketId: Int, status: TicketStatus) throws -> Bool {
        guard (try fetchAssignedTickets(agent: agent).contains(where: { $0.getTicketId == ticketId })) else {
            print("Agent does not have this ticket assigned. Cannot update status.")
            return false
        }

        guard let ticket = try getTicketById(ticketId: ticketId) else {
            print("Ticket not found with ID: \(ticketId)")
            return false
        }
        
        ticket.statusProperty = status
        let result = ticketDao.updateTicketStatus(ticketId: ticketId, status: status)
        
        switch result {
        case .success() :
            try logsEntryController?.log(logType: LogType.info, message: "Ticket status updated to \(status) for ticketId: \(ticketId) by agent.", userId: ticketId, data: ticket)
            return true
            
        case .failure(let error) :
            throw error
        }
    }
    
    func closeTicket(agent: Agent, ticketId: Int, solution : String)throws -> Bool {
        
        guard (try fetchAssignedTickets(agent: agent).contains(where: { $0.getTicketId == ticketId })) else {
            return false
        }
        
        guard let ticket = try getTicketById(ticketId: ticketId) else {
            print("Ticket not found with ID: \(ticketId)")
            return false
        }
        
        if (ticket.statusProperty != TicketStatus.solved ){
            try delegate?.resolveTicket(agent: agent, ticketId: ticketId)
        }
        
        if (try updateTicketStatus(agent: agent, ticketId: ticketId, status: TicketStatus.closed) ){
            try knowleggeBaseController?.addEntry(title: ticket.getTicketTitle, issueType: ticket.getIssueType, solution: solution, createdDate: Date(), lastUpdatedDate: Date(), userId: agent.getUserId)
            try logsEntryController?.log(logType: LogType.info, message: "Ticket Closed for ticketId: \(ticketId) by AgentId : \(agent.getId)", userId: ticket.getUserId, data: ticket)
            return true
        }
        
        return false
    }
    
    func cancelTicket(user: User, ticketId: Int) throws -> Bool {
        let tickets = try getAllTheCreatedTickets(user: user)

        guard tickets.contains(where: { $0.getTicketId == ticketId }) else {
            throw DatabaseError.noRecordFound("Ticket with ID \(ticketId) not found for user.")
        }

        guard let ticket = try getTicketById(ticketId: ticketId) else {
            throw DatabaseError.noRecordFound("No ticket found with ID \(ticketId).")
        }

        let result = ticketDao.updateTicketStatus(ticketId: ticketId, status: TicketStatus.cancelled)
        switch result {
            case .success() :
            try logsEntryController?.log(logType: LogType.info, message: "Ticket cancelled for ticketId: \(ticketId) by UserId: \(user.getId)", userId: user.getId, data: ticket)
                return true
            case .failure(let error) :
                throw error
        }
    }

    func findAgentByTicketId(ticketId: Int)throws -> Agent? {
        let result = ticketDao.findAgentByTicketId(ticketId: ticketId)
        switch result {
        case .success(let agent) :
            return agent
        case .failure(let error) :
            throw error
        }
    }
    
    func prioritizeTicket(ticket: Ticket, userId: Int) throws {
        let user = try userController?.getUserById(userId: userId)
        var priority : Priority = Priority(rawValue: 1) ?? Priority.medium
        if user?.userRoleProperty == UserRole.vip{
            priority = Priority.high
        }
        else if user?.userRoleProperty == UserRole.standard{
            priority = Priority.medium
        }
        else if user?.userRoleProperty == UserRole.guest{
            priority = Priority.low
        }
        ticketDao.updatePriority(ticketId: ticket.getTicketId, newPriority: priority.rawValue)
    }
    
    func reassignTicket(ticketId: Int, agentId: Int) throws -> Bool {
        guard let ticket = try getTicketById(ticketId: ticketId) else {
            print("No ticket found with ID: \(ticketId)")
            return false
        }
        
        if let oldAgentId =  try getAgentIdByTicketId(ticketId: ticketId) , oldAgentId != 0 {
            let oldAgent =  try agentController?.getAgentById(agentId: oldAgentId)
             guard let newAgent = try agentController?.getAgentById(agentId: agentId) else {
                 print("No Old agent found with ID: \(agentId)")
                 return false
             }
            return try reAssignTicket(ticket: ticket, oldAgent: oldAgent!, newAgent: newAgent)
        }
        else {
            
            guard let newAgent = try agentController?.getAgentById(agentId: agentId) else {
                print("No New agent found with ID: \(agentId)")
                return false
            }
            return try reAssignTicket(ticket: ticket, newAgent: newAgent)
        }
    }

    private func reAssignTicket(ticket: Ticket, newAgent: Agent) throws -> Bool {
        guard let controller = agentController else {
            return false
        }
        try controller.reAssignTicketToAgent(ticket: ticket, agent: newAgent)
        return true
    }

    private func reAssignTicket(ticket: Ticket, oldAgent: Agent, newAgent: Agent) throws -> Bool {
        let assignedTickets = try fetchAssignedTickets(agent: oldAgent)
        guard assignedTickets.contains(where: { $0.getTicketId == ticket.getTicketId }) else {
            print("Ticket ID \(ticket.getTicketId) is not assigned to Agent ID: \(oldAgent.getAgentId).")
            return false
        }
        
        let result = ticketDao.removeTicket(agentId: oldAgent.getAgentId, ticketId: ticket.getTicketId)
        switch result {
        case .success():
            try agentController?.reAssignTicketToAgent(ticket: ticket, agent: newAgent)
            
            try logsEntryController?.log(
                logType: .info,
                message: "Ticket reassigned from Agent ID: \(oldAgent.getAgentId) to Agent ID: \(newAgent.getAgentId)",
                userId: oldAgent.getUserId,
                data: newAgent
            )
            return true
            
        case .failure(let error):
            throw error
        }
    }

    func getTicketById(ticketId : Int) throws -> Ticket? {
        let result = ticketDao.getTicketById(ticketId: ticketId)
        switch result {
        case .success(let ticket) :
            return ticket
        case .failure(let error) :
            throw error
        }
    }
    
    func getTicketByDate(date: Date) throws -> [Ticket] {
        let result = try ticketDao.getTicketByDate(date: date)
        switch result {
        case .success(let ticket) :
            return ticket
        case .failure(let error) :
            throw error
        }
    }
    
    func getAllCreatedTickets()throws -> [Ticket] {
        let result = try ticketDao.getAllTickets()
        switch result {
        case .success(let tickets) :
            return tickets
        case .failure(let error) :
            throw error
        }
    }
    
    func getTicketsBetweendates(date1 : Date, date2 : Date) throws -> [Ticket] {
        let result = try ticketDao.getTicketsBetweendates(date1: date1, date2: date2)
            switch result {
            case .success(let tickets) :
                return tickets
            case .failure(let error) :
                throw error
        }
    }
    
}
