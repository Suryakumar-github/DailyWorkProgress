//
//  AgentView.swift
//  HelpDeskManagement
//
//  Created by incubation on 07/11/24.
//
import Foundation

struct AgentView {
    private weak var ticketController : TicketController?
    private weak var knowledgeBase : KnowledgeBaseController?
    private weak var agentController : AgentControllerImpl?
    private var loginedAgent : Agent?
    
    mutating func setTicketController(ticketController : TicketControllerImpl) {
        self.ticketController = ticketController
    }
    mutating func setAgentController(agentController : AgentControllerImpl) {
        self.agentController = agentController
    }
    mutating func setKnowledgeBaseController(knowledgeBaseController : KnowledgeBaseControllerImpl) {
        self.knowledgeBase = knowledgeBaseController
    }
    mutating func setLoginedUser(agent : Agent) {
        self.loginedAgent = agent
    }
    
    func agentMenu() {
        print("==== Agent Dashboard ====")
        print("................................")
        print("1. View Assigned Tickets")
        print("2. Update Ticket Status")
        print("3. Search Knowledge Base")
        print("4. Add Entry In Knowledge Base")
        print("5. Update Agent Availability")
        print("6. Resolve Ticket")
        print("7. Close Ticket")
        print("8. Logout")
        print("................................")
        print("Choose an Option ")
        let option = Int(readLine()!)
        
        switch option {
        case 1 :
            viewAssignedTickets(loginedAgent: loginedAgent!)
        case 2 :
            updateTicketStatus(agent : loginedAgent!)
        case 3 :
            searchKnowledgeBase()
        case 4:
            addKnowledgeBaseEntry()
        case 5 :
            updateAgentAvailability(agent : loginedAgent!)
        case 6:
            resolveTicket(agent : loginedAgent!)
        case 7 :
            closeTicket(agent : loginedAgent!)
        case 8:
            mainView.showLoginScreen()
        default :
            print("Invalid Option")
            agentMenu()
        }
    }
    
    func updateAgentAvailability(agent : Agent) {
        print("Enter the userId: ")
        
        guard let userIdString = readLine(), let userId = Int(userIdString) else {
            print("Invalid input. Please enter a valid user ID.")
            return
        }
        
        print("Enter Agent's Status (available, busy, leave, offline):")
        
        guard let agentStatusString = readLine(),
              let agentStatus = AgentStatus(rawValue: agentStatusString.lowercased()) else {
            print("Invalid status. Please enter a valid status (available, busy, leave, offline).")
            return
        }
        
        if ((agentController?.updateAgentAvailability(agent: agent, status: agentStatus)) != nil){
            print("Agent status updated successfully ")
        }
        else {
            print("Agent status not updated ")
        }
        let logsEntry = LogsEntry(timestamp: Date(), logType: LogType.info, message: "Agent Availablity is Updated", userId: userId)
        DataStorage.allLogsEntry[userId] = logsEntry
        agentMenu()
    }
    
    func closeTicket(agent : Agent) {
        print("Enter the ticket ID to Close :")
        guard let ticketId = Int(readLine()!) else {
            print("Invalid ticket ID.")
            resolveTicket(agent: agent)
            return
        }
        if ((ticketController?.closeTicket(agent : agent,ticketId: ticketId)) != nil) {
            print("Ticket Closed")            
        }
        else {
            print("Ticket Not Closed")
        }
        agentMenu()
    }

    func resolveTicket(agent : Agent) {
        print("Enter the ticket ID:")
        guard let ticketId = Int(readLine()!) else {
            print("Invalid ticket ID.")
            resolveTicket(agent: agent)
            return
        }
        guard let userId = ticketController?.getUserIdByTicketId(ticketId: ticketId) else {
            print("No User Found For TicketId : \(ticketId)")
            resolveTicket(agent: agent)
            return
        }
        agentController?.resolveTicket(agent : agent, ticketId: ticketId, userId: userId)
        agentMenu()
    }
    
    func viewAssignedTickets(loginedAgent : Agent) {
        
        guard let tickets = ticketController?.fetchAssignedTickets(agent: loginedAgent) else {
            print("No tickets Assigned For Agent")
            return
        }
        print("----------------------------------------------------------------")
        for index in 0..<tickets.count {
            print("----------------------------------------------------------------")
            print("Ticket Id : \(String(describing: tickets[index].getTicketId))")
            print("Ticket Title : \(String(describing: tickets[index].getTicketTitle))")
            print("Ticket Description : \(String(describing: tickets[index].descriptionproperty))")
            print("Ticket Priority : \(String(describing: tickets[index].priorityProperty))")
        }
        print("----------------------------------------------------------------")
        agentMenu()
    }
    
    func updateTicketStatus(agent : Agent) {
        print("Enter the ticket ID:")
        guard let ticketId = Int(readLine()!) else {
            print("Invalid ticket ID.")
            return
        }

        print("Enter the status (opened, closed, solved, cancelled, onHold):")
        let statusInput = readLine()!

        if let status = TicketStatus(status: statusInput) {
            if((ticketController?.updateTicketStatus(agent : agent, ticketId: ticketId, status: status) ) != nil) {
                print("Ticket status updated ")
            }
            else {
                print("Invalid Ticket Id ")
            }
        } else {
            print("Invalid status entered.")
        }
        let logsEntry = LogsEntry(timestamp: Date(), logType: LogType.info, message: "Ticket Status is Updated", userId: ticketId)
        DataStorage.allLogsEntry[ticketId] = logsEntry
        agentMenu()
    }
    
    func searchKnowledgeBase() {
        print("Enter the Ticket Title:")
        guard let ticketTitle = readLine(), !ticketTitle.isEmpty else {
            print("Invalid Title")
            return
        }
        print("Enter the Tag:")
        guard let tag = readLine(), !tag.isEmpty else {
            print("Invalid Ticket tag")
            return
        }

        if let knowledgeBaseEntry = knowledgeBase?.search(title: ticketTitle, tag: tag) {
            print("-----------------Problem Solution-----------------------")
            print("--------------------------------------------------------")
            print("Title: \(knowledgeBaseEntry.titleproperty )")
            print("Solution: \(knowledgeBaseEntry.solutionProperty )")
            print("---------------------------------------------------------")
        } else {
            print("No matching knowledge base entry found.")
        }

        agentMenu()
    }

    func addKnowledgeBaseEntry() {
        print("Enter the Title:")
        guard let title = readLine(), !title.isEmpty  else {
            print("Invalid Title")
            return
        }
        
        print("Enter the issue type (network, software, hardware, security):")
        guard let issueTypeInput = readLine(), let issueType = IssueType(status: issueTypeInput) else {
            print("Invalid Issue Type")
            return
        }
        
        print("Enter the Solution:")
        guard let solution = readLine(), !solution.isEmpty else {
            print("Invalid Solution")
            return
        }
        
        print("Enter the Tags (comma-separated if multiple):")
        guard let tagInput = readLine(), !tagInput.isEmpty else {
            print("Invalid Tags")
            return
        }
        
        let tags = tagInput.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        knowledgeBase?.addEntry(
            title: title,
            issueType: issueType,
            solution: solution,
            tags: tags,
            createdDate: Date(),
            lastUpdatedDate: Date()
        )
        let logsEntry = LogsEntry(timestamp: Date(), logType: LogType.info, message: "One Entry Added In KnowledgeBase", userId: nil)
        DataStorage.allLogsEntry[0] = logsEntry
        agentMenu()
    }
}
