//
//  AgentControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//

import Foundation

class AgentControllerImpl : AgentController {
    
    private var userController : UserController?
    private var ticketController : TicketController?
    private var knowledgeBaseController : KnowledgeBaseController?
    
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
    
    func assignTicketToAgent(ticket: Ticket) -> Bool {
        let agents = DataStorage.allAgents
        
        for (_, agent) in agents {  
            if agent.statusProperty == AgentStatus.available {
                agent.assignedTicketsProperty.append(ticket)
                let logsEntry = LogsEntry(timestamp: Date(), logType: LogType.info, message: "Ticket is Assigned To Agent, agentId : \(agent.getId)", userId: agent.getId)
                DataStorage.allLogsEntry[logsEntry.getId] = logsEntry
                return true
            }
        }
        
        return false
    }

    func updateAgentAvailability(agentId: Int, status: AgentStatus) -> Bool {
        let agent = getAgentById(agentId : agentId)
        agent?.statusProperty = status
        let logsEntry = LogsEntry(timestamp: Date(), logType: LogType.info, message: "Agent Availablity is Updated", userId: agentId)
        DataStorage.allLogsEntry[logsEntry.getId] = logsEntry
        return true
    }
    
    func resolveTicket(ticketId: Int, userId: Int) {
        if let ticket = ticketController?.getTicketById(ticketId: ticketId),
           var user = userController?.getUserById(userId: userId) {
            let knowlegeBase = knowledgeBaseController?.search(title: ticket.getTicketTitle, tag: ticket.descriptionproperty)
            if knowlegeBase != nil {
                if ((userController?.notifyUser(ticket: ticketId, description: ticket.descriptionproperty, user: &user)) != nil) {
                    ticket.statusProperty = TicketStatus.closed
                }
            }
            else if ((userController?.notifyUser(ticket: ticketId, description: ticket.descriptionproperty, user: &user)) != nil) {
                ticket.statusProperty = TicketStatus.closed
                knowledgeBaseController?.addEntry(title: ticket.getTicketTitle, issueType: IssueType.softwareIssue, solution: ticket.descriptionproperty, tags: [ticket.getTicketTitle], createdDate: Date(), lastUpdatedDate: nil)
            }
        } else {
            print("Ticket or user not found.")
        }
        let logsEntry = LogsEntry(timestamp: Date(), logType: LogType.info, message: "Ticket is solved ", userId: ticketId)
        DataStorage.allLogsEntry[logsEntry.getId] = logsEntry
    }
    
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
        
        if let agent = DataStorage.allAgents[agentId] {
            return agent
        }
        return nil
    }
    
    func assignAgentAvailability() {
        let agents = DataStorage.allAgents
        
        for index in 0..<agents.count {
            if let agent = agents[index] {
                if  agent.assignedTicketsProperty.count > 5 && getAgentWorkLoad(agent: agent) > 1 {
                    agent.statusProperty = AgentStatus.busy
                }
                else if agent.assignedTicketsProperty.count < 5 && getAgentWorkLoad(agent: agent) < 2 {
                    agent.statusProperty = AgentStatus.available
                }
            }
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
                lowPriorityTicketCounts += 1
                
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
        let agent = Agent(name: name, department: department, userName: userName, password: password)
        DataStorage.allAgents[agent.getId] = agent
        let logsEntry = LogsEntry(timestamp: Date(), logType: LogType.info, message: "New Agent Added", userId: agent.getId)
        DataStorage.allLogsEntry[logsEntry.getId] = logsEntry
    }
}
