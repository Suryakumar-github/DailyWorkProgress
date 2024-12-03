//
//  AgentControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//

import Foundation

class AgentControllerImpl : AgentController {
   
    private weak var ticketController : TicketController?
    private var knowledgeBaseController : KnowledgeBaseController?
    private let agentDao : AgentDAO = AgentDAOImpl()
    private let userDao : UserDAO = UserDAOImpl()
    
    func setTicketController(ticketController: TicketController) {
        self.ticketController = ticketController
    }
    
    func setKnowledgeBaseController(knowledgeBaseController: KnowledgeBaseController) {
        self.knowledgeBaseController = knowledgeBaseController
    }
    
    func closeTicket(agent: Agent, ticketId: Int)throws -> Bool{
        guard let controller = ticketController else {
            return false
        }
        if (try controller.closeTicket(agent: agent, ticketId: ticketId) ){
            return true
        }
        return false
    }
    
    func checkAgentAvailability(agentId: Int)throws -> AgentStatus {
        let agent = try getAgentById(agentId : agentId)
        return agent!.statusProperty
    }
    
    func updateAgentAvailability(agent: Agent, status: AgentStatus) throws -> Bool {
        agent.statusProperty = status
        let result = agentDao.updateAgentAvailability(agent: agent, status: status)
        switch result {
        case .success() :
            try Logger.log(logType: LogType.info, message: "Agent Availablity is Updated", userId: agent.getId, data: agent)
            return true
        case .failure(let error) :
            throw error
        }
        
    }
    
    func updateTicketStatus(agent : Agent, ticketId: Int, status: TicketStatus)throws -> Bool {
        
        guard let controller = ticketController else {
            return false
        }
        if (try controller.updateTicketStatus(agent: agent, ticketId: ticketId, status: status)) {
            return true
        }
        return false
    }

    func changePassword(agent : Agent, newPassword: String, currentPassword: String)throws -> Bool {

        let result = agentDao.getUserNameAndPassword(userId: agent.getUserId)
        switch result {
        case .success(let credentials) :
             let storedPassword = credentials[1]

            if storedPassword != currentPassword {
                print("Current password is incorrect.")
                return false
            }

            if storedPassword == newPassword {
                print("New password cannot be the same as the current password.")
                return false
            }
            
            let result = agentDao.changePassword(agent: agent, newPassword: newPassword)
            switch result {
            case .success():
                return true
            case .failure(let error):
                throw error
            }
            
        case .failure(let error) :
            throw error
        }
    }
    
    func fetchAssignedTickets(agent: Agent) throws -> [Ticket] {
        guard let tickets = try ticketController?.fetchAssignedTickets(agent: agent) else {
            return [] 
        }
        
        return tickets.filter { ticket in
            ticket.statusProperty != .cancelled && ticket.statusProperty != .closed
        }
    }

    
    func getAgentById(agentId : Int)throws -> Agent? {
        
        let result = agentDao.getAgentById(agentId: agentId)
        switch result {
        case .success(let agent):
            return agent
        case .failure(let error):
            throw error
        }
    }
    
    func assignAgentAvailability(agent: Agent) throws {
        let tickets = try fetchAssignedTickets(agent: agent)
        if tickets.isEmpty {
            print("No tickets assigned to the agent.")
            return
        }
        
        let workload = try getAgentWorkLoad(agent: agent)
        
        if tickets.count > 5 && workload > 1 {
            agent.statusProperty = .busy
        } else if tickets.count <= 5 && workload < 2 {
            agent.statusProperty = .available
        }
    }

    func getAgentWorkLoad(agent: Agent) throws -> Int {
        let tickets = try fetchAssignedTickets(agent: agent)
        if tickets.isEmpty {
            return 0
        }

        var priorityCounts: [Priority: Int] = [.high: 0, .medium: 0, .low: 0]

        for ticket in tickets {
            if let priority = ticket.priorityProperty {
                priorityCounts[priority, default: 0] += 1
            }
        }

        let highPriorityTicketCounts = priorityCounts[.high] ?? 0
        let mediumPriorityTicketCounts = priorityCounts[.medium] ?? 0
        let lowPriorityTicketCounts = priorityCounts[.low] ?? 0

        let totalCount = highPriorityTicketCounts * 3 + mediumPriorityTicketCounts * 2 + lowPriorityTicketCounts

        if highPriorityTicketCounts <= 2 {
            return totalCount < 8 ? 1 : 2
        } else if totalCount > 8 {
            return 2
        }

        return 0
    }
    
    func addEntry(title: String, issueType : IssueType, solution: String, tags: [String], createdDate: Date, lastUpdatedDate: Date?, userId : Int)throws {
        try knowledgeBaseController?.addEntry(title: title, issueType: issueType, solution: solution, tags: tags, createdDate: createdDate, lastUpdatedDate: lastUpdatedDate, userId: userId)
    }
    
    func getAllKnowledgeBaseEntries() throws -> [KnowledgeBase] {
        return try knowledgeBaseController?.getAllKnowledgeBaseEntries() ?? []
    }
    
    func addAgent(name : String, department : String, userName : String, password : String)throws {
        let id : Int
        let userId = userDao.getLastCreatedUserId()
        switch userId {
        case .success(let newId) :
            id = newId + 1
        case .failure(let error) :
            throw error
        }
        //let hashedPassword = StringHasher.hash(password)
        let user = User(userId: id, name: name, userRole: UserRole.vip, role: Role.agent)
        let agent = Agent(name : name,deparment: department, userId: id)
        let ans = userDao.addUser(user: user)
        let result = agentDao.addAgent(agent: agent)
        switch result {
        case .success() :
            try Logger.log(logType: LogType.info, message: "New Agent Added with AgentId : \(agent.getId)", userId: agent.getId, data: agent)
            agentDao.addAgentUserNamePassword(userName: userName, password: password, agent: agent)
        case .failure(let error) :
            throw error
        }
    }
    
    func search(word: String) throws -> [KnowledgeBase] {
        return try knowledgeBaseController?.search(word: word) ?? []
    }
    
    func getAllAgents() throws -> [Agent] {
        let result = agentDao.getAllAgents()
        switch result {
        case .success(let agents) :
            return agents
        case .failure(let error) :
            throw error
        }
    }
    
    func reAssignTicketToAgent(ticket: Ticket, agent : Agent) throws {
        let addTicketResult = agentDao.addTicketToAgent(agent: agent, ticket: ticket)
        
        switch addTicketResult {
        case .success():
            let assignAgentResult = agentDao.assignAgentToTicket(agentId: agent.getAgentId, ticketId: ticket.getTicketId)
            
            switch assignAgentResult {
            case .success():
                try assignAgentAvailability(agent: agent)
                try updateTicketStatus(agent: agent, ticketId: ticket.getTicketId, status: TicketStatus.reassigned)
                try Logger.log(
                    logType: .info,
                    message: "Ticket successfully assigned to Agent, agentId: \(agent.getId)",
                    userId: agent.getUserId,
                    data: agent
                )
                
            
            case .failure(let error):
                throw error
            }
            
        case .failure(let error):
            throw error
        }
    }
    
    deinit{
        
    }
}

extension AgentControllerImpl : TicketAssignmentDelegate {
    func resolveTicket(agent: Agent, ticketId: Int) throws {
        
        guard let userId = try ticketController?.getUserIdByTicketId(ticketId: ticketId) else {
            print("No User Found For Ticket ID: \(ticketId)")
            print("----------------------------------------------------------------")
            return
        }
        
        guard (try fetchAssignedTickets(agent: agent).contains(where: { $0.getTicketId == ticketId })) else {
            print("Agent does not have this ticket assigned. Cannot resolve ticket.")
            return
        }
        
        guard (try ticketController?.getTicketById(ticketId: ticketId)) != nil else {
            print("Ticket not found with ID: \(ticketId)")
            return
        }
        
        try ticketController?.updateTicketStatus(agent: agent, ticketId: ticketId, status: TicketStatus.solved)
        agentDao.updateTicketsResolvedCount(agentId: agent.getAgentId, newCount: agent.ticketResolvedProperty+1)
        try Logger.log(logType: LogType.info, message: "Ticket with TicketId \(ticketId) resolved for user with UserId \(userId).", userId: agent.getId, data: agent)
        print("Ticket with ID \(ticketId) has been successfully resolved.")
    }
    
    func assignTicketToAgent(ticket: Ticket) throws -> Bool {
        let result = agentDao.getAllAgents()
        
        switch result {
        case .success(let agents):
            for agent in agents {
                if ticket.getIssueType.rawValue.lowercased() == agent.departmentProperty.lowercased(),
                   agent.statusProperty == .available {
                    
                    let addTicketResult = agentDao.addTicketToAgent(agent: agent, ticket: ticket)
                    
                    switch addTicketResult {
                    case .success():
                        let assignAgentResult = agentDao.assignAgentToTicket(agentId: agent.getAgentId, ticketId: ticket.getTicketId)
                        
                        switch assignAgentResult {
                        case .success():
                            try assignAgentAvailability(agent: agent)
                            
                            try Logger.log(
                                logType: .info,
                                message: "Ticket successfully assigned to Agent, agentId: \(agent.getId)",
                                userId: agent.getUserId,
                                data: agent
                            )
                            
                            return true
                        
                        case .failure(let error):
                            throw error
                        }
                        
                    case .failure(let error):
                        throw error
                    }
                }
            }
            
            return false
            
        case .failure(let error):
            throw error
        }
    }


}
