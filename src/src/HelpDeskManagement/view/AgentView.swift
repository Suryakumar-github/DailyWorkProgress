//
//  AgentView.swift
//  HelpDeskManagement
//
//  Created by incubation on 07/11/24.
//
import Foundation

struct AgentView {
    private var ticketController : TicketController?
    private var knowledgeBase : KnowledgeBaseController?
    //private lazy var mainView = MainView()
    
    mutating func setTicketController(ticketController : TicketControllerImpl) {
        self.ticketController = ticketController
    }
    mutating func setKnowledgeBaseController(knowledgeBaseController : KnowledgeBaseControllerImpl) {
        self.knowledgeBase = knowledgeBaseController
    }
    
    func agentMenu() {
        print("==== Agent Dashboard ====")
        print("................................")
        print("1. View Assigned Tickets")
        print("2. Update Ticket Status")
        print("3. Search Knowledge Base")
        print("4. Add Entry In Knowledge Base")
        print("5. Logout")
        print("................................")
        print("Choose an Option ")
        let option = Int(readLine()!)
        
        switch option {
        case 1 :
            viewAssignedTickets()
        case 2 :
            updateTicketStatus()
        case 3 :
            searchKnowledgBase()
        case 4:
            addKnowledgeBaseEntry()
        case 5:
            mainView.showLoginScreen()
            
        default :
            print("Invalid Option")
        }
    }
    
    func viewAssignedTickets() {
        let tickets = ticketController?.fetchAssignedTickets(agentId: 1)
        for index in 0..<tickets!.count {
            print("Ticket Id : \(String(describing: tickets?[index].getTicketId))")
            print("Ticket Title : \(String(describing: tickets?[index].getTicketTitle))")
            print("Ticket Description : \(String(describing: tickets?[index].descriptionproperty))")
            print("Ticket Priority : \(String(describing: tickets?[index].priorityProperty))")
        }
        agentMenu()
    }
    
    func updateTicketStatus() {
        print("Enter the ticket ID:")
        guard let ticketId = Int(readLine()!) else {
            print("Invalid ticket ID.")
            return
        }

        print("Enter the status (opened, closed, solved, cancelled, onHold):")
        let statusInput = readLine()!

        if let status = TicketStatus(status: statusInput) {
            if((ticketController?.updateTicketStatus(ticketId: ticketId, status: status) ) != nil) {
                print("Ticket status updated successfully.")
            }
            else {
                print("Invalid Ticket Id ")
            }
        } else {
            print("Invalid status entered.")
        }
        
        agentMenu()
    }
    
    func searchKnowledgBase() {
        print("Enter the Title:")
        guard let title = readLine(), !title.isEmpty else {
            print("Invalid Ticket Title")
            return
        }
            
        print("Enter the Tag:")
        let tag = readLine() ?? ""
        
        let knowledgeBaseEntry = knowledgeBase?.search(title: title, tag: tag)
        print("Title : \(String(describing: knowledgeBaseEntry?.titleproperty))")
        print("Solution : \(String(describing: knowledgeBaseEntry?.solutionProperty)) ")
        
        agentMenu()
    }
    

    func addKnowledgeBaseEntry() {
        print("Enter the Title:")
        guard let title = readLine(), !title.isEmpty else {
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
        
        agentMenu()
    }
}
