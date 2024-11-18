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
        print("8. Change Password")
        print("9. Logout")
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
        case 4 :
            addKnowledgeBaseEntry()
        case 5 :
            updateAgentAvailability(agent : loginedAgent!)
        case 6:
            resolveTicket(agent : loginedAgent!)
        case 7 :
            closeTicket(agent : loginedAgent!)
        case 8 :
            changePassword(agent : loginedAgent!)
        case 9 :
            mainView.showLoginScreen()
        default :
            print("Invalid Option")
            agentMenu()
        }
    }
    
    func updateAgentAvailability(agent : Agent) {
        print("----------------------------------------------------------------")
        print("Enter Agent's Status (available, busy, leave, offline):")
        
        guard let agentStatusString = readLine(),
              let agentStatus = AgentStatus(rawValue: agentStatusString.lowercased()) else {
            print("Invalid status. Please enter a valid status (available, busy, leave, offline).")
            updateAgentAvailability(agent: agent)
            return
        }
        
        if ((agentController?.updateAgentAvailability(agent: agent, status: agentStatus)) != nil){
            //print("Agent status updated successfully ")
        }
        else {
            print("Agent status not updated ")
            updateAgentAvailability(agent: agent)
            print("----------------------------------------------------------------")
        }
        print("----------------------------------------------------------------")
        agentMenu()
    }
    
    func changePassword(agent : Agent) {
        print("----------------------------------------------------------------")
        print("Enter Password:")
        guard let password = readLine(), !password.isEmpty && Validation.validatePassword(password) else {
            print("Invalid Password")
            changePassword(agent: agent)
            return
        }
        if ((agentController?.changePassword(agent: agent, newPassword : password)) != nil) {
            print("Password Changed Successfully ")
            print("----------------------------------------------------------------")
        }
        else {
            print("Old Password and New Password should not be same ")
            print("----------------------------------------------------------------")
        }
    }
    
    func closeTicket(agent: Agent) {
        print("----------------------------------------------------------------")
        
        while true {
            print("Enter the ticket ID (or type 'exit' to go back):")
            
            if let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) {
                if input.lowercased() == "exit" {
                    print("Exiting to Agent Menu...")
                    agentMenu()
                    return
                }
                
                guard let ticketId = Int(input) else {
                    print("Invalid ticket ID. Please enter a valid numeric ticket ID.")
                    continue
                }
                
                guard let controller = ticketController else {
                    print("TicketController is nil. Cannot proceed.")
                    return
                }
                
                if controller.closeTicket(agent: agent, ticketId: ticketId) {
                    print("Ticket \(ticketId) successfully closed.")
                    print("----------------------------------------------------------------")
                    agentMenu()
                } else {
                    print("Failed to close ticket \(ticketId). Either it doesn't exist or you are not authorized.")
                    print("----------------------------------------------------------------")
                }
            }
        }
    }


    func resolveTicket(agent: Agent) {
        print("----------------------------------------------------------------")
        while true {
            print("Enter the ticket ID (or type 'exit' to go back):")
            
            if let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) {
                if input.lowercased() == "exit" {
                    print("Exiting to Agent Menu...")
                    agentMenu()
                    return
                }
                
                if let ticketId = Int(input) {
                    guard let userId = ticketController?.getUserIdByTicketId(ticketId: ticketId) else {
                        print("No User Found For Ticket ID: \(ticketId)")
                        print("----------------------------------------------------------------")
                        continue
                    }
                    
                    agentController?.resolveTicket(agent: agent, ticketId: ticketId, userId: userId)
                    print("----------------------------------------------------------------")
                    agentMenu()
                    return
                } else {
                    print("Invalid input. Please enter a valid ticket ID or type 'exit' to go back.")
                    
                }
            }
        }
    }

    func viewAssignedTickets(loginedAgent : Agent) {
        print("----------------------------------------------------------------")
        guard let tickets = ticketController?.fetchAssignedTickets(agent: loginedAgent) else {
            print("No tickets Assigned For Agent")
            return
        }
        if(tickets.count == 0) {
            print("-------------No Tickets Assigned for Agent--------------- ")
            agentMenu()
        }
        print("----------------------------------------------------------------")
        print("                      Assigned Tickets                          ")
        for index in 0..<tickets.count {
            
            print("----------------------------------------------------------------")
            print("Ticket Id : \(String(describing: tickets[index].getTicketId))")
            print("Ticket Title : \(String(describing: tickets[index].getTicketTitle))")
            print("Ticket Description : \(String(describing: tickets[index].descriptionproperty))")
            print("Ticket Priority : \(String(describing: tickets[index].priorityProperty!))")
        }
        print("----------------------------------------------------------------")
        agentMenu()
    }
    
    func updateTicketStatus(agent : Agent) {
        print("----------------------------------------------------------------")
        print("Enter the ticket ID:")
        guard let ticketId = Int(readLine()!) else {
            print("Invalid ticket ID.")
            updateTicketStatus(agent: agent)
            return
        }

        print("Enter the status (opened, closed, solved, cancelled, onHold):")
        let statusInput = readLine()!

        if let status = TicketStatus(status: statusInput) {
            if((ticketController?.updateTicketStatus(agent : agent, ticketId: ticketId, status: status) ) != nil) {
            }
            else {
                print("Invalid Ticket Id ")
                updateTicketStatus(agent: agent)
            }
        } else {
            print("Invalid status entered.")
        }
        print("----------------------------------------------------------------")
        agentMenu()
    }
    
    func searchKnowledgeBase() {
        print("------------------Available Title's---------------------")
        let entries = DataStorage.knowledgeBaseEntry
        print("--------------------------------------------------------")
        for (_,entry) in entries {
            print("Title : \(entry.titleproperty)")
            print("Tag : \(entry.tagsProperty)")
        }
        print("--------------------------------------------------------")
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
        print("----------------------------------------------------------------")
        var title: String?
        var issueType: IssueType?
        var solution: String?
        var tags: [String]?

        while title == nil || issueType == nil || solution == nil || tags == nil {
            if title == nil {
                print("Enter the Title:")
                if let input = readLine(), !input.isEmpty {
                    title = input
                } else {
                    print("Invalid Title. Please enter a non-empty title.")
                    continue
                }
            }
            
            if issueType == nil {
                print("Enter the issue type (network, software, hardware, security):")
                if let issueTypeInput = readLine(), let parsedIssueType = IssueType(status: issueTypeInput) {
                    issueType = parsedIssueType
                } else {
                    print("Invalid Issue Type. Please enter a valid issue type.")
                    continue
                }
            }
            
            if solution == nil {
                print("Enter the Solution:")
                if let input = readLine(), !input.isEmpty {
                    solution = input
                } else {
                    print("Invalid Solution. Please enter a non-empty solution.")
                    continue
                }
            }
            
            if tags == nil {
                print("Enter the Tags (comma-separated if multiple):")
                if let tagInput = readLine(), !tagInput.isEmpty {
                    tags = tagInput.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                } else {
                    print("Invalid Tags. Please enter at least one tag.")
                    continue
                }
            }
        }
        
        knowledgeBase?.addEntry(
            title: title!,
            issueType: issueType!,
            solution: solution!,
            tags: tags!,
            createdDate: Date(),
            lastUpdatedDate: Date()
        )
        print("----------------------------------------------------------------")
        agentMenu()
    }
}
