//
//  AgentView.swift
//  HelpDeskManagement
//
//  Created by incubation on 07/11/24.
//
import Foundation

struct AgentView {
    private var agentController : AgentControllerImpl?
    private var loginedAgent : Agent?
    private var ticketController : TicketControllerImpl
    private var knowledgeBaseController : KnowledgeBaseControllerImpl
    private var logsEntryController : LogsEntryController
    
    init()   {
        ticketController =   TicketControllerImpl()
        knowledgeBaseController =   KnowledgeBaseControllerImpl()
        logsEntryController = LogsEntryControllerImpl()
    }
    
    mutating func setAgentController(agentController : AgentControllerImpl) {
        self.agentController = agentController
    }

    mutating func setLoginedUser(agent : Agent) {
        self.loginedAgent = agent
    }
    
    func agentMenu()   {
        
        print("----------------------------------------------------------------")
        print("                    ==== Agent Dashboard ====                   ")
        print("----------------------------------------------------------------")
        print("1. View Tickets")
        print("2. Update Ticket Status")
        print("3. Search Knowledge Base")
        print("4. Add Entry In Knowledge Base")
        print("5. Update Agent Availability")
        print("6. Solve Ticket")
        print("7. Close Ticket")
        print("8. Change Password")
        print("9. Logout")
        print("----------------------------------------------------------------")
        print("Choose an Option ")
        let option = Int(readLine()!)
        
        switch option {
        case 1 :
              viewTickets(loginedAgent: loginedAgent!)
        case 2 :
              updateTicketStatus(agent : loginedAgent!)
        case 3 :
              searchKnowledgeBase()
        case 4 :
              addKnowledgeBaseEntry(agent : loginedAgent!)
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
    
    private func updateAgentAvailability(agent : Agent)   {
        agentController?.setLogsEntryController(logsEntryController: logsEntryController)
        ticketController.setDelagate(ticketAssignmentDelegate: agentController!)
        print("---------------------------------------------------------------------------------")
        print("Agent's Current Status : \(agent.statusProperty)")
        print("Enter Agent's Status (1 : available, 2 : busy, 3 : leave, 4 : offline, (or enter '0' to go back) ")
        let choice = Int(readLine()!)
        var agentStatus : AgentStatus = AgentStatus.available
        switch choice {
        case 0:
            print("Going Back to Agent Menu..")
              agentMenu()
        case 1 :
            agentStatus = AgentStatus.available
        case 2 :
            agentStatus = AgentStatus.busy
        case 3 :
            agentStatus = AgentStatus.leave
        case 4 :
            agentStatus = AgentStatus.offline
        default :
            print("Invalid status. Please enter a valid status (available, busy, leave, offline).")
              updateAgentAvailability(agent: agent)
        }
        do {
            guard let controller = agentController else {
                print("Agent controller is Nil..")
                return
            }
            if   (try controller.updateAgentAvailability(agent: agent, status: agentStatus)){
                print("Agent status updated successfully ")
            }
            else {
                print("Agent status not updated ")
                  updateAgentAvailability(agent: agent)
                print("---------------------------------------------------------------------------------")
            }
            print("---------------------------------------------------------------------------------")
        }
        catch let error {
            print("Error while Update Agent Availabilty : \(error.localizedDescription)")
            print("---------------------------------------------------------------------------------")
        }
          agentMenu()
    }
    
    private func changePassword(agent: Agent)   {
        print("----------------------------------------------------------------")
        
        var currentPassword: String?
        while currentPassword == nil {
            print("Enter the Current Password (or enter 0 to go back):")
            if let input = readLine(), !input.isEmpty {
                if input == "0" {
                    print("Going Back to Agent Menu..")
                      agentMenu()
                    return
                }
                currentPassword = input
            } else {
                print("Invalid Password. Please try again.")
            }
        }

        var newPassword: String?
        while newPassword == nil {
            print("Enter New Password (or enter 0 to go back):")
            if let input = readLine(), !input.isEmpty {
                if input == "0" {
                    print("Going Back to Agent Menu..")
                      agentMenu()
                    return
                }
                if Validation.validatePassword(input) {
                    newPassword = input
                } else {
                    print("Please enter a valid password (that should contains length as atleast 5 Character's one Number, one Special Character and start's with Alphabet")
                }
            } else {
                print("Password cannot be empty. Please try again.")
            }
        }
        
        do {
            if let result = try   agentController?.changePassword(agent: agent, newPassword: newPassword!, currentPassword: currentPassword!) {
                if result {
                    print("Password Changed Successfully.")
                } else {
                    print("Old Password and New Password should not be the same.")
                }
            } else {
                print("Failed to change the password. Please try again.")
            }
        } catch let error {
            print("Error while updating the password: \(error.localizedDescription)")
            print("----------------------------------------------------------------")
        }
        
        print("----------------------------------------------------------------")
          agentMenu()
    }
    
    private func closeTicket(agent: Agent) {
        ticketController.setLogsEntryController(logsEntryController: logsEntryController)
        ticketController.setDelagate(ticketAssignmentDelegate: agentController!)
        agentController?.setTicketController(ticketController: ticketController)
        print("----------------------------------------------------------------")
        do {
            guard let tickets = try   agentController?.fetchAssignedTickets(agent: agent), !tickets.isEmpty else {
                print("             you don't have any Tickets to Close              ")
                print("----------------------------------------------------------------")
                  agentMenu()
                return
            }
            
            print("----------------------------------------------------------------")
            print("                      Assigned Tickets                          ")
            
            for ticket in tickets {
                print("----------------------------------------------------------------")
                print("Ticket Id          : \(ticket.getTicketId)")
                print("Ticket Title       : \(ticket.getTicketTitle)")
                print("Ticket Description : \(ticket.descriptionproperty)")
                print("Ticket Priority    : \(ticket.priorityProperty!)")
                print("Ticket Status      : \(ticket.statusProperty)")
            }
            print("----------------------------------------------------------------")
        }
        catch let error {
            print("Error while fetching the tickets : \(error.localizedDescription)")
            print("----------------------------------------------------------------")
        }
        while true {
            print("Enter the ticket ID (or type '0' to go back):")
            
            if let input = Int(readLine()!) {
                if input == 0 {
                    print("Going Back to Agent Menu..")
                      agentMenu()
                    return
                }
                print("------------------------------------------------------------------------------------")
                print("1 . Like to provide the solution for the Ticket's Issue and Add to KnowledgeBase  ")
                print("2 . Skip the Process ")
                print("3 . to Go Back ")
                print("------------------------------------------------------------------------------------")
                print("Please Choose an Option")
                var solution = ""
                let choice = Int(readLine()!)
                switch choice {
                case 1 :
                    print("Enter The Solution.")
                    solution = readLine()!
                case 2 :
                    solution = ""
                case 3 :
                    print("Going Back To Agent Menu..")
                    agentMenu()
                default :
                    print("Inavlid Choice Please try again.")
                    closeTicket(agent: agent)      
                }
                    
                guard let controller = agentController else {
                    print("AgentController is nil. Cannot proceed.")
                    return
                }
                do {
                    if try   controller.closeTicket(agent: agent, ticketId: input, solution: solution) {
                        print("Ticket \(input) successfully closed.")
                        print("----------------------------------------------------------------")
                          agentMenu()
                        return
                    } else {
                        print("Failed to close ticket \(input). Either it doesn't exist or you are not authorized.")
                        print("----------------------------------------------------------------")
                    }
                }
                catch let error {
                    print("Error while closing the Ticket : \(error.localizedDescription)")
                    print("----------------------------------------------------------------")
                }
            }
        }
          agentMenu()
    }
    
    private func viewTickets(loginedAgent : Agent) {
        print("----------------------------------------------------------------")
        print("                    ==== Ticket Menu ===                        ")
        print("----------------------------------------------------------------")
        print("1. View All Tickets")
        print("2. View Tickets by Ticket Status")
        print("3. Go Back")
        print("----------------------------------------------------------------")
        print("Choose an option:")
        
        if let choice = Int(readLine() ?? "") {
            switch choice {
            case 1:
                  viewAllTicket(loginedAgent: loginedAgent)
            case 2:
                viewTicketBystatus(loginedAgent : loginedAgent)
            case 3:
                print("Exiting Tickets Viewer.!")
                agentMenu()
            default:
                print("Invalid choice. Please try again.")
                viewTickets(loginedAgent: loginedAgent)
            }
        }
    }
    
    private func viewAllTicket(loginedAgent: Agent)    {
        agentController?.setTicketController(ticketController: ticketController)
        print("----------------------------------------------------------------")
        do {
            guard let controller = agentController else {
                print("Agent Controller is Nil..")
                return
            }
            let tickets = try controller.getAllTickets(agent: loginedAgent)
            
            if tickets.isEmpty {
                print("                No tickets Assigned For Agent                   ")
                print("----------------------------------------------------------------")
                agentMenu()
            }
                        
            print("----------------------------------------------------------------")
            print("                      Assigned Tickets                          ")
            
            for ticket in tickets {
                
                print("----------------------------------------------------------------")
                print("Ticket Id          : \(ticket.getTicketId)")
                print("Ticket Title       : \(ticket.getTicketTitle)")
                print("Ticket Description : \(ticket.descriptionproperty)")
                print("Ticket Priority    : \(ticket.priorityProperty!)")
                print("Ticket Status      : \(ticket.statusProperty)")
            }
            print("----------------------------------------------------------------")
        }
        catch let error {
            print("Error while fetching the tickets : \(error.localizedDescription)")
            print("----------------------------------------------------------------")
            viewTickets(loginedAgent: loginedAgent)
        }
        print("Type 0 to return to the main menu or press any key to view allTickets :")
        if let input = readLine(), input == "0" {
            print("----------------------------------------------------------------")
            viewTickets(loginedAgent: loginedAgent)
        } else {
            viewAllTicket(loginedAgent: loginedAgent)
        }
    }
    
    private func viewTicketBystatus(loginedAgent : Agent) {
        agentController?.setTicketController(ticketController: ticketController)
        print("----------------------------------------------------------------")
        print("Choose the Ticket Status to view Tickets : (1. assigned, 2. onHold, 3. opened, 4. solved, 5. closed, (or type '0' to go back)")
        var status : TicketStatus?
        let choice = Int(readLine()!)
        switch choice {
        case 0 :
            print("Going back to Ticket Menu..")
            viewTickets(loginedAgent: loginedAgent)
        case 1 :
            status = TicketStatus.assigned
        case 2 :
            status = TicketStatus.onHold
        case 3 :
            status = TicketStatus.opened
        case 4 :
            status = TicketStatus.solved
        case 5 :
            status = TicketStatus.closed
        default :
            print("Invalid Choice. Please try again.")
            viewTicketBystatus(loginedAgent: loginedAgent)
        }
        do {
            guard let controller = agentController else {
                print("Agent Controller is Nil..")
                return
            }
            let tickets = try   controller.getTicketByStatus(agent: loginedAgent, status : status ?? TicketStatus.assigned)
            
            if tickets.isEmpty {

                    print("          No Tickets availablr For The Provided Status          ")
                    print("----------------------------------------------------------------")
                print("Type 0 to return to the main menu or press any key to view Tickets for another Status : ")
                if let input = readLine(), input == "0" {
                    print("----------------------------------------------------------------")
                    viewTickets(loginedAgent: loginedAgent)
                } else {
                    viewTicketBystatus(loginedAgent: loginedAgent)
                }
            }
                        
            print("----------------------------------------------------------------")
            print("                      Assigned Tickets                          ")
            
            for ticket in tickets {
                
                print("----------------------------------------------------------------")
                print("Ticket Id          : \(ticket.getTicketId)")
                print("Ticket Title       : \(ticket.getTicketTitle)")
                print("Ticket Description : \(ticket.descriptionproperty)")
                print("Ticket Priority    : \(ticket.priorityProperty!)")
                print("Ticket Status      : \(ticket.statusProperty)")
            }
            print("----------------------------------------------------------------")
        }
        catch let error {
            print("Error while fetching the tickets : \(error.localizedDescription)")
            print("----------------------------------------------------------------")
            viewTickets(loginedAgent: loginedAgent)
        }
        
        print("Type 0 to return to the main menu or press any key to view Tickets for another Status:")
        if let input = readLine(), input == "0" {
            print("----------------------------------------------------------------")
            viewTickets(loginedAgent: loginedAgent)
        } else {
            viewTicketBystatus(loginedAgent: loginedAgent)
        }
          
    }
    
    private func resolveTicket(agent: Agent)   {
        agentController?.setTicketController(ticketController: ticketController)
        print("----------------------------------------------------------------")
        do {
            guard let tickets = try   agentController?.fetchAssignedTickets(agent: agent), !tickets.isEmpty else {
                print("             You Don't Have any Tickets to Solve              ")
                print("----------------------------------------------------------------")
                  agentMenu()
                return
            }
            
            print("----------------------------------------------------------------")
            print("                      Assigned Tickets                          ")
            
            for ticket in tickets {
                
                print("----------------------------------------------------------------")
                print("Ticket Id          : \(ticket.getTicketId)")
                print("Ticket Title       : \(ticket.getTicketTitle)")
                print("Ticket Description : \(ticket.descriptionproperty)")
                print("Ticket Priority    : \(ticket.priorityProperty!)")
                print("Ticket Status      : \(ticket.statusProperty)")
            }
            print("----------------------------------------------------------------")
        }
        catch let error {
            print("Error while fetching the tickets : \(error.localizedDescription)")
            print("----------------------------------------------------------------")
        }
        while true {
            print("Enter the ticket ID (or type '0' to go back):")
            
            if let input = Int(readLine()!) {
                if input == 0 {
                    print("Going Back to Agent Menu..")
                      agentMenu()
                    return
                }
                do {
                    guard let controller = agentController else {
                        print("Agent Controller is Nil..")
                        return
                    }
                    if   ( try controller.resolveTicket(agent: agent, ticketId: input) ) {
                        print("Ticket with ID \(input) has been successfully resolved.")
                        print("----------------------------------------------------------------")
                          agentMenu()
                    }
                      agentMenu()
                }
                catch let error {
                    print("Error while resolving the Ticket : \(error.localizedDescription)")
                    print("----------------------------------------------------------------")
                }
            }
        }
    }
    
    private func updateTicketStatus(agent: Agent)   {
        ticketController.setLogsEntryController(logsEntryController: logsEntryController)
        agentController?.setTicketController(ticketController: ticketController)
        print("----------------------------------------------------------------")

        do {
            guard let tickets = try   agentController?.fetchAssignedTickets(agent: agent), !tickets.isEmpty else {
                print("             you don't have any Tickets to update              ")
                print("----------------------------------------------------------------")
                  agentMenu()
                return
            }
            
            print("----------------------------------------------------------------")
            print("                      Assigned Tickets                          ")
            for ticket in tickets {
                print("----------------------------------------------------------------")
                print("Ticket Id     : \(ticket.getTicketId)")
                print("Ticket Title  : \(ticket.getTicketTitle)")
                print("Ticket Status : \(ticket.statusProperty)")
            }
            print("----------------------------------------------------------------")
        } catch let error {
            print("Error while fetching tickets: \(error.localizedDescription)")
            print("----------------------------------------------------------------")
              agentMenu()
            return
        }
        
        while true {
            
            print("Enter the ticket ID to update (or type '0' to go back):")
            
            guard let input = Int(readLine()!), input >= 0 else {
                print("Invalid input. Please enter a valid ticket ID or '0' to go back.")
                continue
            }
            
            if input == 0 {
                print("Going back to Agent Menu...")
                print("----------------------------------------------------------------")
                  agentMenu()
                return
            }
            
            print("Enter the status (1: Closed, 2: Solved, 3: On Hold, 4: Opened, or enter '0' to go back):")
            let statusInput = Int(readLine()!)
            
            if statusInput == 0 {
                print("Going back to Agent Menu..")
                  agentMenu()
            }
            
            let status: TicketStatus
            switch statusInput {
            case 1:
                status = .closed
            case 2:
                status = .solved
            case 3:
                status = .onHold
            case 4 :
                status = .opened
            default:
                print("Invalid status entered. Please try again.")
                continue
            }
            
            guard let controller = agentController else {
                print("AgentController is nil. Cannot proceed.")
                return
            }
            
            do {
                let isUpdated = try   controller.updateTicketStatus(agent: agent, ticketId: input, status: status)
                
                if isUpdated {
                    print("Ticket \(input) status successfully updated to \(status).")
                    print("----------------------------------------------------------------")
                      agentMenu()
                    return
                } else {
                    print("No ticket found with ID \(input). Please try again.")
                }
            } catch let error {
                print("Error while updating ticket: \(error.localizedDescription)")
                print("----------------------------------------------------------------")
            }
        }
    }
    
    private func searchKnowledgeBase()   {
        agentController?.setKnowledgeBaseController(knowledgeBaseController: knowledgeBaseController)
        print("----------------------------------------------------------------")
        print("                 ==== KnowledgeBase Menu ===                    ")
        print("----------------------------------------------------------------")
        print("1. View All KnowledgeBase Entry")
        print("2. Search Using Specific Word")
        print("3. Go back")
        print("----------------------------------------------------------------")

        
        print("Please Choose an Option")
        let choice = Int(readLine()!)
        if choice == 1 {
            do {
                guard let entries = try   agentController?.getAllKnowledgeBaseEntries(), !entries.isEmpty else {
                    print("No Entries Found ")
                      agentMenu()
                    return
                }
                print("-------------------- Available Entrie's -------------------------")
                
                for (entry) in entries {
                    print("Title    : \(entry.titleproperty)")
                    print("Issue    : \(entry.issueProperty)")
                    print("Solution : \(entry.solutionProperty)")
                    print("----------------------------------------------------------------")
                }
                
            }
            catch let error {
                print("Error while fetching the data : \(error.localizedDescription)")
                print("----------------------------------------------------------------")
            }
              agentMenu()
        }
        else if choice == 2 {
            print("Enter the word to Search")
            guard let word = readLine(), !word.isEmpty else {
                print("Invalid Word")
                  searchKnowledgeBase()
                return
            }
            do {
                if let knowledgeBaseEntry = try   agentController?.search(word: word), !knowledgeBaseEntry.isEmpty {
                    print("------------------- Available Entrie's  ------------------------")
                    print("----------------------------------------------------------------")
                    for entry in knowledgeBaseEntry {
                        print("Title    : \(entry.titleproperty)")
                        print("Issue    : \(entry.issueProperty)")
                        print("Solution : \(entry.solutionProperty)")
                        print("----------------------------------------------------------------")
                    }
                }
                else {
                    print("No Solutions Found for the Given Word..")
                      agentMenu()
                }
            }
            catch let error {
                print("Error while Fetching the data : \(error.localizedDescription)")
                print("----------------------------------------------------------------")
            }
        }
        else if choice == 3 {
            print("Going Back to Agent Menu..")
              agentMenu()
        }
        else {
            print("Invalid Option")
              searchKnowledgeBase()
        }
        
          agentMenu()
    }

    private func addKnowledgeBaseEntry(agent : Agent)   {
        knowledgeBaseController.setLogsEntryController(logsEntryController: logsEntryController)
        agentController?.setKnowledgeBaseController(knowledgeBaseController: knowledgeBaseController)
        print("----------------------------------------------------------------")
        var title: String?
        var issueType: IssueType?
        var solution: String?
        

        while title == nil || issueType == nil || solution == nil {
            if title == nil {
                print("Enter the Title: or enter '0' to go back ")
                let input = readLine()!
                if input == "0" {
                    print("Going back to Agent Menu..")
                      agentMenu()
                }
                else if !input.isEmpty {
                    title = input
                }
                 else {
                    print("Invalid Title. Please enter a non-empty title.")
                    continue
                }
            }
            
            if issueType == nil {
                print("Enter the issue type (1 : for network, 2 : for software, 3 : for hardware, 4 : for security): or enter '5' to go back  ")
                let choice = Int(readLine()!)
                switch choice {
                    case 1 :
                        issueType = IssueType.network
                    case 2 :
                        issueType = IssueType.software
                    case 3 :
                        issueType = IssueType.hardware
                    case 4 :
                        issueType = IssueType.security
                    case 5 :
                    print("Going back to Agent Menu..")
                      agentMenu()
                    default :
                        print("Enter the valid Option")
                        continue
                }
            }
            
            if solution == nil {
                print("Enter the Solution: or enter '0' to go back")
                let input = readLine()!
                if input == "0" {
                    print("Going back to Agent Menu..")
                      agentMenu()
                }
                else if !input.isEmpty {
                    solution = input
                }
                 else {
                    print("Invalid Solution. Please enter a non-empty solution.")
                    continue
                }
            }
            
        }
        do {
            try   agentController?.addEntry(
                title: title!,
                issueType: issueType!,
                solution: solution!,
                createdDate: Date(),
                lastUpdatedDate: Date(), userId: agent.getId
            )
            print("KnowldgeBase Entry Added Successfully")
            print("----------------------------------------------------------------")
        }
        catch let error {
            print(error.localizedDescription)
            print("----------------------------------------------------------------")
        }
          agentMenu()
    }
}
