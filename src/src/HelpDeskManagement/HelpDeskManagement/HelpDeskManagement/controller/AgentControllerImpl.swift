//
//  AgentControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//

import Foundation

class AgentControllerImpl : AgentController {
   
    private weak var userController : UserController?
    private weak var ticketController : TicketController?
    private weak var knowledgeBaseController : KnowledgeBaseController?
    
    func setTicketController(ticketController: TicketController) {
        self.ticketController = ticketController
    }
    
    func setUserController(userController: UserController) {
        self.userController = userController
    }
    
    func setKnowledgeBaseController(knowledgeBaseController: KnowledgeBaseController) {
        self.knowledgeBaseController = knowledgeBaseController
    }
    
    func checkAgentAvailability(agentId: Int) -> AgentStatus {
        let agent = getAgentById(agentId : agentId)
        return agent!.statusProperty
    }
    
    func updateAgentAvailability(agent: Agent, status: AgentStatus) -> Bool {
        agent.statusProperty = status
        Logger.log(logType: LogType.info, message: "Agent Availablity is Updated", userId: agent.getId, data: agent)
        return true
    }
    
//    func resolveTicket(ticketId: Int, userId: Int) {
//        print("Attempting to resolve ticket with ticketId: \(ticketId) and userId: \(userId)")
//        if (userController == nil) {
//            print("Usercontroller is nil")
//            return
//        }
//        if (ticketController == nil) {
//            print("TicketController is nil")
//            return
//        }
//        guard let ticket = ticketController?.getTicketById(ticketId: ticketId) else {
//            print("Ticket not found with ID: \(ticketId)")
//            return
//        }
//        
//        guard var user = userController?.getUserById(userId: userId) else {
//            print("User not found with ID: \(userId)")
//            return
//        }
//        
//        print("Ticket found with ID: \(ticket.getTicketId), User found with ID: \(user.getUserId)")
//        
//        if let knowledgeBase = knowledgeBaseController?.search(title: ticket.getTicketTitle, tag: ticket.descriptionproperty) {
//            print("Knowledge Base entry found: \(knowledgeBase.titleproperty)")
//            
//            if userController?.notifyUser(ticket: ticketId, description: knowledgeBase.solutionProperty, user: &user) != nil {
//                ticket.statusProperty = .closed
//                print("User notified with knowledge base solution. Ticket closed.")
//            } else {
//                print("Failed to notify user.")
//            }
//        } else {
//            print("No Knowledge Base entry found. Creating a new entry.")
//            
//            if userController?.notifyUser(ticket: ticketId, description: ticket.descriptionproperty, user: &user) != nil {
//                ticket.statusProperty = .closed
//                print("User notified with new ticket resolution. Ticket closed.")
//                
//                knowledgeBaseController?.addEntry(
//                    title: ticket.getTicketTitle,
//                    issueType: .softwareIssue,
//                    solution: ticket.descriptionproperty,
//                    tags: [ticket.getTicketTitle],
//                    createdDate: Date(),
//                    lastUpdatedDate: nil
//                )
//                print("New Knowledge Base entry added.")
//            } else {
//                print("Failed to notify user.")
//            }
//        }
//        
//        let logEntry = LogsEntry(
//            timestamp: Date(),
//            logType: .info,
//            message: "Ticket woth TickedId \(ticketId) resolved for user with UserId \(userId).",
//            userId: userId
//        )
//        
//        DataStorage.allLogsEntry[logEntry.getId] = logEntry
//        print("Log entry added: \(logEntry.messageProperty)")
//    }
    
    func trackAgentPerfomance(agentId: Int) -> AgentPerfomance? {
        guard let agent = getAgentById(agentId: agentId) else {
                print("Agent not found.")
                return nil
            }
        
        if agent.ticketResolvedProperty == agent.assignedTicketsProperty.count {
            agent.perfomanceProperty = AgentPerfomance.Super
        }
        else if agent.ticketResolvedProperty > agent.assignedTicketsProperty.count / 2 {
            agent.perfomanceProperty = AgentPerfomance.Average
        }
        else if agent.ticketResolvedProperty < agent.assignedTicketsProperty.count / 2 {
            agent.perfomanceProperty = AgentPerfomance.Poor
        }
        return agent.perfomanceProperty
    }
    
    func getAgentById(agentId : Int) -> Agent? {
        
        return Logger.getItemById(from: DataStorage.allAgents, id: agentId)
    }
    
    func assignAgentAvailability(agent : Agent) {
        
        if (agent.assignedTicketsProperty.count > 5 && getAgentWorkLoad(agent: agent) > 1) {
            agent.statusProperty = AgentStatus.busy
        }
        else if agent.assignedTicketsProperty.count < 5 && getAgentWorkLoad(agent: agent) < 2 {
            agent.statusProperty = AgentStatus.available
        }
    }
    
    func getAgentWorkLoad(agent : Agent) -> Int {
        let tickets = agent.assignedTicketsProperty
        var highPriorityTicketCounts = 0
        var mediumPriorityTicketCounts = 0
        var lowPriorityTicketCounts = 0
        
        for ticket in tickets {
            switch ticket.priorityProperty {
            case .high:
                highPriorityTicketCounts += 1
            case .medium:
                mediumPriorityTicketCounts += 1
            case .low:
                lowPriorityTicketCounts += 1
            default :
                lowPriorityTicketCounts += 0
                
            }
        }
        
        let totalCount = highPriorityTicketCounts * 3 + mediumPriorityTicketCounts * 2 + lowPriorityTicketCounts
        if highPriorityTicketCounts <= 2 && totalCount < 8 {
            return 1
        }
        else if highPriorityTicketCounts <= 2 && totalCount > 8 {
            return 2
        }
        else if highPriorityTicketCounts > 2 && totalCount > 8 {
            return 2
        }
        return 0
    }
    
    func addAgent(name : String, department : String, userName : String, password : String) {
        let agent = Agent(name: name, deparment: department, userName: userName, password: password)
        DataStorage.allAgents[agent.getId] = agent
        Logger.log(logType: LogType.info, message: "New Agent Added with AgentId : \(agent.getId)", userId: agent.getId, data: agent)
    }
}

extension AgentControllerImpl : TicketAssignmentDelegate {
    func resolveTicket(agent: Agent, ticketId: Int, userId: Int) {
        guard agent.assignedTicketsProperty.contains(where: { $0.getTicketId == ticketId }) else {
            print("Agent does not have this ticket assigned. Cannot resolve ticket.")
            return
        }
        
        guard let ticket = ticketController?.getTicketById(ticketId: ticketId) else {
            print("Ticket not found with ID: \(ticketId)")
            return
        }
        
        ticket.statusProperty = TicketStatus.solved
        Logger.log(logType: LogType.info, message: "Ticket with TicketId \(ticketId) resolved for user with UserId \(userId).", userId: agent.getId, data: agent)
        print("Ticket with ID \(ticketId) has been successfully resolved.")
    }
    
    func assignTicketToAgent(ticket: Ticket) -> Bool {
        let agents = DataStorage.allAgents
        
        for (_, agent) in agents {
            if agent.statusProperty == AgentStatus.available {
                agent.assignedTicketsProperty.append(ticket)
                assignAgentAvailability(agent: agent)
                Logger.log(logType: LogType.info, message: "Ticket is Assigned To Agent, agentId : \(agent.getId)", userId: agent.getId, data: agent)
                return true
            }
        }
        return false
    }
}
