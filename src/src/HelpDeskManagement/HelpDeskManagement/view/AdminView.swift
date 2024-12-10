//
//  AdminView.swift
//  HelpDeskManagement
//
//  Created by incubation on 07/11/24.
//
import Foundation

struct AdminView {
    
    private var adminController : AdminController?
    private var loginedUser : Admin?
    private let reportGenerator = ReportAndAnalyticsControllerImpl()
    private var ticketController : TicketControllerImpl
    private var agentController : AgentControllerImpl
    
    init()   {
        ticketController =   TicketControllerImpl()
        agentController =   AgentControllerImpl()
    }
 
    mutating func setAdminController(adminController : AdminController) {
        self.adminController = adminController
    }
    mutating func setLoginedUser(user : Admin) {
        self.loginedUser = user
    }
    
    func adminMenu() {
        print("----------------------------------------------------------------")
        print("                    ==== Admin Dashboard ====                   ")
        print("----------------------------------------------------------------")
        print("1. Add Agent")
        print("2. View Agents")
        print("3. View Tickets")
        print("4. Generate Ticket Reports")
        print("5. Generate Agent Reports")
        print("6. Reassign Tickets")
        print("7. View Logs Entry")
        print("8. Change Password")
        print("9. Logout")
        print("----------------------------------------------------------------")
        print("Select an option: ")
        let option = Int(readLine()!)
        
        switch option {
            
        case 1 :
              addAgent()
        case 2 :
              viewAgents()
        case 3 :
              viewTickets()
        case 4 :
              generateTicketReport()
        case 5 :
              generateAgentReport()
        case 6 :
              reassignTicket()
        case 7 :
              viewLogsEntry()
        case 8 :
              changePassword(user: loginedUser!)
        case 9 :
            mainView.showLoginScreen()
        default :
            print("Invalid Option")
              adminMenu()
        }
    }
    
    private func viewAgents() {
        print("----------------------------------------------------------------")
        print("                    ==== Agent Menu ===                        ")
        print("----------------------------------------------------------------")
        print("1. View All Agents")
        print("2. View Agents By Agent Status")
        print("3. Go back")
        print("----------------------------------------------------------------")
        print("Choose an option:")
        
        let choice = Int(readLine()!)
        switch choice {
        case 1 :
            viewAllAgents()
        case 2 :
            viewAgentByStatus()
        case 3 :
            print("Going Back to Admin Menu..")
            adminMenu()
        default :
            print("Invalid Choice. Please try again.")
            viewAgents()
        }
    }
    
    private func viewAgentByStatus() {
        adminController?.setAgentController(agentController: agentController)
        print("----------------------------------------------------------------")
        print("Choose the Ticket Status to view Tickets : (1. available, 2. busy, 3. leave, 4. offline, (or type '0' to go back)")
        var status : AgentStatus?
        let choice = Int(readLine()!)
        switch choice {
        case 0 :
            print("Going back to Agent Menu..")
            viewAgents()
        case 1 :
            status = AgentStatus.available
        case 2 :
            status = AgentStatus.busy
        case 3 :
            status = AgentStatus.leave
        case 4 :
            status = AgentStatus.offline
        default :
            print("Invalid Choice. Please try again.")
            viewAgentByStatus()
        }
        do {
            guard let allAgents = try adminController?.getAgentByStatus(status: status ?? AgentStatus.available), !allAgents.isEmpty else {
                print("   No agent found with status : \(String(describing: status?.rawValue))   ")
                print("----------------------------------------------------------------")
                print("Type 0 to return to the main menu or press any key to view another Agent by status :")
                if let input = readLine(), input == "0" {
                    print("----------------------------------------------------------------")
                    viewAgents()
                } else {
                    viewAllAgents()
                }
                return
            }

            print("----------------------------------------------------------------")
            print("                        Available Agents                        ")
            
            for (agent) in allAgents {
                print("----------------------------------------------------------------")
                print("Agent ID           : \(agent.getAgentId)")
                print("Agent Name         : \(agent.getName)")
                print("Agent Department   : \(agent.departmentProperty)")
                print("Agent Availability : \(agent.statusProperty)")
            }
            print("----------------------------------------------------------------")
              
        } catch let error {
            print("Error occurred while fetching agents: \(error.localizedDescription)")
            print("----------------------------------------------------------------")
        }
        print("Type 0 to return to the main menu or press any key to view another Agent by status:")
        if let input = readLine(), input == "0" {
            print("----------------------------------------------------------------")
            viewAgents()
        } else {
            viewAgentByStatus()
        }
    }
    
    private func viewAllAgents()   {
        adminController?.setAgentController(agentController: agentController)
        print("----------------------------------------------------------------")
        do {
            guard let allAgents = try   adminController?.getAllAgents(), !allAgents.isEmpty else {
                print("                       No agents found.                         ")
                print("----------------------------------------------------------------")
                  adminMenu()
                return
            }

            print("----------------------------------------------------------------")
            print("                        Available Agents                        ")
            
            for (agent) in allAgents {
                print("----------------------------------------------------------------")
                print("Agent ID           : \(agent.getAgentId)")
                print("Agent Name         : \(agent.getName)")
                print("Agent Department   : \(agent.departmentProperty)")
                print("Agent Availability : \(agent.statusProperty)")
            }
            print("----------------------------------------------------------------")
              
        } catch let error {
            print("Error occurred while fetching agents: \(error.localizedDescription)")
            print("----------------------------------------------------------------")
        }
        print("Type 0 to return to the main menu or press any key to view all agents:")
        if let input = readLine(), input == "0" {
            print("----------------------------------------------------------------")
            viewAgents()
        } else {
            viewAllAgents()
        }
    }
    
    func changePassword(user: Admin)   {
        print("----------------------------------------------------------------")
        
        while true {
            
            print("Enter the Current Password, (or type '0' to go back) : ")
            guard let currentPassword = readLine(), !currentPassword.isEmpty else {
                print("Invalid input. Current password cannot be empty.")
                continue
            }
            
            if currentPassword == "0" {
                print("Going back to Main Menu..")
                  adminMenu()
            }
            
            print("Enter the New Password, (or type '0' to go back) : ")
            guard let newPassword = readLine(), !newPassword.isEmpty else {
                print("Invalid input. New password cannot be empty.")
                continue
            }
            
            if newPassword == "0" {
                print("Going back to Main Menu..")
                  adminMenu()
            }
            
            if !Validation.validatePassword(newPassword) {
                print("Please enter a valid password (that should contains length as atleast 5 Character's one Number, one Special Character and start's with Alphabet")
                continue
            }
            
            guard let controller = adminController else {
                print("Error: Admin controller is not available.")
                  adminMenu()
                return
            }
            
            do {
                if try   controller.updatePassword(user: user , newPassword: newPassword, currentPassword: currentPassword) {
                    print("Password changed successfully.")
                    print("----------------------------------------------------------------")
                      adminMenu()
                } else {
                    print("New password cannot be the same as the current password.")
                    print("----------------------------------------------------------------")
                      changePassword(user: user)
                }
            } catch {
                print("Error while changing password: \(error.localizedDescription)")
                print("----------------------------------------------------------------")
                  adminMenu()
            }
        }
    }
    
    private func addAgent()   {
        agentController.setLogsEntryController(logsEntryController: LogsEntryControllerImpl())
        adminController?.setAgentController(agentController: agentController)
        var agentName: String?
        var agentDepartment: String?
        var agentUserName: String?
        var agentPassword: String?
        
        print("----------------------------------------------------------------")
        while agentName == nil || agentDepartment == nil || agentUserName == nil || agentPassword == nil {
            if agentName == nil {
                print("Enter the Agent's Name, (or type '0' to go back) : ")
                let inputName = readLine()!
                if Validation.validateName(inputName) {
                    agentName = inputName
                }
                else if inputName == "0" {
                    print("Going back to Admin Menu..")
                      adminMenu()
                }
                    else {
                    print("Please enter a valid name.")
                    
                    continue
                }
            }
            
            if agentDepartment == nil {
                print("Enter Agent's Department, (or type '0' to go back) : ")
                let inputDepartment = readLine()!
                if Validation.validateName(inputDepartment) {
                    agentDepartment = inputDepartment
                }
                else if inputDepartment == "0" {
                    print("Going back to Admin Menu..")
                      adminMenu()
                }
                    else {
                    print("Please enter a valid department.")
                    continue
                }
            }
            
            if agentUserName == nil {
                print("Enter Agent's UserName, (or type '0' to go back) : ")
                let inputUserName = readLine()!
                if Validation.validateUsername(inputUserName) {
                    agentUserName = inputUserName
                }
                else if inputUserName == "0" {
                    print("Exiting to Admin Menu..")
                      adminMenu()
                }
                else {
                    print("Please enter a valid username.")
                    continue
                }
            }
            
            if agentPassword == nil {
                print("Enter Agent's Password, (or type '0' to go back) : ")
                let inputPassword = readLine()!
                if Validation.validatePassword(inputPassword) {
                    agentPassword = inputPassword
                }
                else if inputPassword == "0" {
                    print("Exiting to Admin Menu..")
                      adminMenu()
                }
                else {
                    print("Please enter a valid password (that should contains length as atleast 5 Character's one Number, one Special Character and start's with Alphabet")
                    continue
                }
            }
            
        }
        do {
            try   adminController?.addAgent(name: agentName!, department: agentDepartment!, userName: agentUserName!, password: agentPassword!)
            print("Agent added successfully")
            print("----------------------------------------------------------------")
        }
        catch let error {
            print("Error occured while adding the Agent : \(error.localizedDescription) ")
            print("----------------------------------------------------------------")
        }
       
          adminMenu()
    }
    
    private func viewTickets()   {
        print("----------------------------------------------------------------")
        print("                    ==== Ticket Menu ===                        ")
        print("----------------------------------------------------------------")
        print("1. View All Tickets")
        print("2. View Ticket By Particular Date")
        print("3. View Tickets Between Two Date's")
        print("4. exit")
        print("----------------------------------------------------------------")
        print("Choose an option:")
        
        if let choice = Int(readLine() ?? "") {
            switch choice {
            case 1:
                  viewAllTicket()
            case 2:
                  viewTicketByDate()
            case 3:
                  viewTicketBetweenDates()
            case 4:
                print("Exiting Tickets Viewer.!")
                  adminMenu()
            default:
                print("Invalid choice. Please try again.")
                  viewTickets()
            }
        } else {
            print("Invalid input. Please enter a number.")
              viewTickets()
        }
        
    }
    
    private func viewTicketByDate()   {
        adminController?.setTicketController(ticketController: ticketController)
        print("----------------------------------------------------------------")
        print("Enter the Date to view Tickets (format: yyyy-MM-dd), (or type '0' to go back)")
        
        guard let dateString = readLine(), !dateString.isEmpty else {
            print("                     Invalid date format                        ")
            print("----------------------------------------------------------------")
              viewTicketByDate()
            return
        }
        
        if dateString == "0" {
            print("----------------------------------------------------------------")
              viewTickets()
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else {
            print("Invalid date format. Please use yyyy-MM-dd.")
              viewTicketByDate()
            return
        }
        
        do {
            print("----------------------------------------------------------------")
            guard let dataEntries = try   adminController?.getTicketByDate(date: date), !dataEntries.isEmpty else {
                print("No entries found for the provided date.")
                  viewTickets()
                return
            }
            
            
            print("                       Available Tickets                        ")
            print("----------------------------------------------------------------")
            for entry in dataEntries {
                print("----------------------------------------------------------------")
                let formattedDate = adminController?.formatDateForDisplay(entry.getTicketCreatedDate)
                print("Ticket Status    : \(String(describing: entry.statusProperty))")
                print("TicketId         : \(entry.getTicketId)")
                print("Ticket's UserId  : \(entry.getUserId)")
                print("Ticket's AgentId : \(String(describing: entry.getAgentId!))")
                print("Created Date     : \(String(describing: formattedDate!))")
                print("----------------------------------------------------------------")
            }
            print("----------------------------------------------------------------")
        } catch let error {
            print(error.localizedDescription)
            print("----------------------------------------------------------------")
        }
        
        print("Type 0 to return to the main menu or press any key to view logs for another date:")
        if let input = readLine(), input == "0" {
            print("----------------------------------------------------------------")
              viewTickets()
        } else {
              viewTicketByDate()
        }
    }
    
    private func viewAllTicket()   {
        adminController?.setTicketController(ticketController: ticketController)
        print("----------------------------------------------------------------")
        do  {
            guard let tickets = try   adminController?.getAllTickets(), !tickets.isEmpty else {
                print("                       No Ticket found.                         ")
                print("----------------------------------------------------------------")
                  adminMenu()
                return
            }
            print("                     Available Tickets                      ")
            print("----------------------------------------------------------------")
            for (ticket) in tickets {
                print("----------------------------------------------------------------")
                let formattedDate = adminController?.formatDateForDisplay(ticket.getTicketCreatedDate)
                print("Ticket Status    : \(String(describing: ticket.statusProperty))")
                print("TicketId         : \(ticket.getTicketId)")
                print("Ticket's UserId  : \(ticket.getUserId)")
                print("Ticket's AgentId : \(String(describing: ticket.getAgentId!))")
                print("Created Date     : \(String(describing: formattedDate!))")
                print("----------------------------------------------------------------")
            }
        }
        catch let error {
            print(error.localizedDescription)
            print("----------------------------------------------------------------")
        }
        
          viewTickets()
    }
    
    private func viewTicketBetweenDates()   {
        adminController?.setTicketController(ticketController: ticketController)
        print("----------------------------------------------------------------")
        print("Enter the Start Date (format: yyyy-MM-dd), (or type '0' to go back) :")
        
        guard let dateString1 = readLine(), !dateString1.isEmpty else {
            print("Invalid input.")
            return
        }
        
        if dateString1 == "0" {
            print("----------------------------------------------------------------")
              viewTickets()
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date1 = dateFormatter.date(from: dateString1) else {
            print("Invalid date format. Please use yyyy-MM-dd.")
              viewTicketBetweenDates()
            return
        }
        
        print("----------------------------------------------------------------")
        print("Enter the End Date (format: yyyy-MM-dd) , (or type '0' to go back) :")
        
        guard let dateString2 = readLine(), !dateString2.isEmpty else {
            print("Invalid input.")
            return
        }
        
        if dateString2 == "0" {
              viewTickets()
            return
        }
        
        guard let date2 = dateFormatter.date(from: dateString2) else {
            print("Invalid date format. Please use yyyy-MM-dd.")
              viewTicketBetweenDates()
            return
        }
        
        do {
            print("----------------------------------------------------------------")
            guard let dataEntries = try   adminController?.getTicketsBetweendates(date1 : date1, date2 : date2), !dataEntries.isEmpty else {
                print("         No entries found between the provided dates.          ")
                print("----------------------------------------------------------------")
                  viewTicketBetweenDates()
                return
            }
            
            
            print("                       Available Tickets                        ")
            print("----------------------------------------------------------------")
            for entry in dataEntries {
                print("----------------------------------------------------------------")
                let formattedDate = adminController?.formatDateForDisplay(entry.getTicketCreatedDate)
                print("Ticket Status    : \(String(describing: entry.statusProperty))")
                print("TicketId         : \(entry.getTicketId)")
                print("Ticket's UserId  : \(entry.getUserId)")
                print("Ticket's AgentId : \(String(describing: entry.getAgentId!))")
                print("Created Date     : \(String(describing: formattedDate!))")
                print("----------------------------------------------------------------")
            }
            print("----------------------------------------------------------------")
        } catch let error {
            print(error.localizedDescription)
            print("----------------------------------------------------------------")
        }
        
        print("( Type '0' to go back) or press any key to view logs for another date range:")
        if let input = readLine(), input == "0" {
            print("----------------------------------------------------------------")
              viewTickets()
        } else {
              viewTicketBetweenDates()
        }
    }
    
    private func generateTicketReport()   {
        reportGenerator.setTicketController(ticketController: ticketController)
        adminController?.setReportAndAnalyticsController(reportAndAnalyticsController: reportGenerator)
        print("----------------------------------------------------------------")
        print("Enter the Date to Generate Report (format: yyyy-MM-dd), (or type '0' to go back) :")
        
        guard let dateString = readLine(), !dateString.isEmpty else {
            print("Invalid date input.")
              generateTicketReport()
            return
        }
        if dateString == "0" {
            print("Going Back to Admin Menu..")
              adminMenu()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else {
            print("Invalid date format. Please use yyyy-MM-dd.")
              generateTicketReport()
            return
        }
        do {
            guard let tickets = try   adminController?.generateTicketReport(date: date) else {
                return
            }
            if (tickets.isEmpty) {
                print("No Tickets Created at the Specified Date")
                print("----------------------------------------------------------------")
                  adminMenu()
            }
            let totalTickets = tickets.count
            let solvedTickets = tickets.filter { $0.statusProperty == .solved }.count
            let closedTickets = tickets.filter { $0.statusProperty == .closed }.count
            let holdedTickets = tickets.filter { $0.statusProperty == .onHold }.count
            let canceledTickets = tickets.filter { $0.statusProperty == .cancelled }.count
            let reassignedTickets = tickets.filter{ $0.statusProperty == .reassigned }.count
            
            print("--------------------------Ticket Report-------------------------")
            print("----------------------------------------------------------------")
            print("Total Tickets Created    : \(totalTickets)")
            print("ReAssigned Tickets Count : \(reassignedTickets)")
            print("Solved Tickets Count     : \(solvedTickets)")
            print("Closed Tickets Count     : \(closedTickets)")
            print("Holded Tickets Count     : \(holdedTickets)")
            print("Canceled Tickets Count   : \(canceledTickets)")
            
            print("----------------------------------------------------------------")
        }
        catch let error {
            print(error.localizedDescription)
            print("----------------------------------------------------------------")
        }
          adminMenu()
    }

    private func generateAgentReport()   {
        reportGenerator.setAgentController(agentController: agentController)
        adminController?.setReportAndAnalyticsController(reportAndAnalyticsController: reportGenerator)
        do {
            guard let allAgents = try   adminController?.getAllAgents() else {
                print("No agents found.")
                  adminMenu()
                return
            }
            print("----------------------------------------------------------------")
            print("                        Available Agents                        ")
            for (agent) in allAgents {
                print("----------------------------------------------------------------")
                print("Agent ID       : \(agent.getAgentId)")
                print("Agent Name     : \(agent.getName)")
            }
            print("----------------------------------------------------------------")
        }
        catch let error {
            print(error.localizedDescription)
              adminMenu()
        }
        
        print("----------------------------------------------------------------")
        print("Enter the Agent ID (or type '0' to go back) :")
        guard let agentId = Int(readLine()!) else {
            print("Invalid ticket ID.")
              generateAgentReport()
            return
        }
        if agentId == 0 {
            print("Going Back to Admin Menu..")
              adminMenu()
        }
        do {
            guard let agent = try   adminController?.generateAgentreport(agentId: agentId) else {
                print("                      No agent Avaialble                        ")
                print("----------------------------------------------------------------")
                  adminMenu()
                return
            }
            
            let agentName = agent.getName
            let assignedTicketsCount = try   adminController?.fetchAssignedTickets(agent: agent).count
            let solvedTicketsCount = agent.ticketResolvedProperty
            
            print("-------------------------Agent Report---------------------------")
            print("Agent Name              : \(agentName)")
            print("Assigned Ticket's Count : \(String(describing: assignedTicketsCount!))")
            print("Solved Ticket's Count   : \(solvedTicketsCount)")
            print("----------------------------------------------------------------")

        }
        catch let error {
            print(error.localizedDescription)
            print("----------------------------------------------------------------")
        }
          adminMenu()
    }
    
    private func reassignTicket()   {
        agentController.setLogsEntryController(logsEntryController: LogsEntryControllerImpl())
        adminController?.setAgentController(agentController: agentController)
        ticketController.setAgentController(agentController: agentController)
        agentController.setTicketController(ticketController: ticketController)
        ticketController.setDelagate(ticketAssignmentDelegate: agentController)
        adminController?.setTicketController(ticketController: ticketController)
        do {
            
            guard let allAgents = try   adminController?.getAllAgents(), !allAgents.isEmpty else {
                print("No agents found.")
                  adminMenu()
                return
            }

            print("----------------------------------------------------------------")
            print("                  Available Agents and Tickets                  ")
            for agent in allAgents {
                print("Agent ID: \(agent.getAgentId)")
                do {
                    if let tickets = try   adminController?.getAgentTickets(agent: agent), !tickets.isEmpty {
                        print("Assigned Tickets:")
                        for ticket in tickets {
                            print("  - Ticket ID: \(ticket.getTicketId)")
                        }
                    } else {
                        print("No tickets assigned.")
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
                print("----------------------------------------------------------------")
            }

            print("Enter the Ticket ID to reassign (or enter 0 to go back):")
            guard let ticketIdInput = Int(readLine()!), ticketIdInput != 0 else {
                print("Exiting Ticket Reassignment.")
                print("----------------------------------------------------------------")
                  adminMenu()
                return
            }

            print("Enter the New Agent ID (or enter 0 to go back):")
            guard let newAgentIdInput = Int(readLine()!), newAgentIdInput != 0 else {
                print("Going Back to Admin Menu..")
                print("----------------------------------------------------------------")
                  adminMenu()
                return
            }

            do {
                if let controller = adminController, try   controller.reassignTicket(ticketId: ticketIdInput, agentId: newAgentIdInput) {
                    print("Ticket successfully reassigned from Ticket ID \(ticketIdInput) to Agent ID \(newAgentIdInput).")
                } else {
                    print("Ticket reassignment failed. Please check the IDs and try again.")
                }
            } catch let error {
                print("Error while reassigning the ticket: \(error.localizedDescription)")
                print("----------------------------------------------------------------")
            }

        } catch let error {
            print("Error occurred while fetching agents: \(error.localizedDescription)")
            print("----------------------------------------------------------------")
        }

          adminMenu()
    }

    private func viewLogsEntry()   {
        while true {
            print("----------------------------------------------------------------")
            print("                       ==== Logs Menu ====                      ")
            print("----------------------------------------------------------------")
            print("1. View All LogsEntry")
            print("2. View Today's LogsEntry")
            print("3. View LogsEntry in Particular Date")
            print("4. View LogsEntry in Between Two Dates")
            print("5. Go back")
            print("----------------------------------------------------------------")
            print("Choose an option:")
            
            if let choice = Int(readLine() ?? "") {
                switch choice {
                case 1:
                      viewAllLogs()
                case 2 :
                      viewTodayLogs()
                case 3:
                      viewLogsByParticularDate()
                case 4:
                      viewLogsBetweenDates()
                case 5:
                    print("Going Back to Admin Menu..")
                      adminMenu()
                default:
                    print("Invalid choice. Please try again.")
                }
            } else {
                print("Invalid input. Please enter a number.")
            }
        }
    }
    
    private func viewTodayLogs()   {
        do {
            print("-----------------------------------------------------------------------------------")
            guard let dataEntries = try   adminController?.getLogsEntryByDate(date: Date()) else {
                print("No entries found for the provided date.")
                return
            }
            if dataEntries.isEmpty {
                print("No Logs Available for the Given Date..")
                  viewLogsEntry()
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            
            print("                                   Log Entries                                    ")
            for entry in dataEntries {
                print("-----------------------------------------------------------------------------------")
                let formattedDate = dateFormatter.string(from: entry.getTimestamp)
                print("Entry ID           : \(entry.getId)")
                print("Entry Created Date : \(String(describing: formattedDate))")
                print("Entry Message      : \(entry.messageProperty)")
            }
            print("-----------------------------------------------------------------------------------")
        } catch let error {
            print("Error while reading logs : \(error.localizedDescription)")
            print("-----------------------------------------------------------------------------------")
        }
    }

    private func viewLogsByParticularDate()   {
        print("----------------------------------------------------------------")
        print("Enter the Date to view Logs (format: yyyy-MM-dd), (or enter 0 to go back) :")
        
        guard let dateString = readLine(), !dateString.isEmpty else {
            print("Invalid input.")
            return
        }
        
        if dateString == "0" {
            print("----------------------------------------------------------------")
              viewLogsEntry()
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else {
            print("Invalid date format. Please use yyyy-MM-dd.")
              viewLogsByParticularDate()
            return
        }
        
        do {
            print("-----------------------------------------------------------------------------------")
            guard let dataEntries = try   adminController?.getLogsEntryByDate(date: date) else {
                print("No entries found for the provided date.")
                return
            }
            if dataEntries.isEmpty {
                print("No Logs Available for the Given Date..")
                  viewLogsEntry()
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            
            print("                                   Log Entries                                    ")
            for entry in dataEntries {
                print("-----------------------------------------------------------------------------------")
                let formattedDate = dateFormatter.string(from: entry.getTimestamp)
                print("Entry ID           : \(entry.getId)")
                print("Entry Created Date : \(String(describing: formattedDate))")
                print("Entry Message      : \(entry.messageProperty)")
            }
            print("-----------------------------------------------------------------------------------")
        } catch let error {
            print("Error while reading logs : \(error.localizedDescription)")
            print("-----------------------------------------------------------------------------------")
        }
        
        print("Type 0 to return to the main menu or press any key to view logs for another date:")
        if let input = readLine(), input == "0" {
            print("-----------------------------------------------------------------------------------")
              viewLogsEntry()
        } else {
              viewLogsByParticularDate()
        }
    }

    
    private func viewLogsBetweenDates()   {
        print("----------------------------------------------------------------")
        print("Enter the Start Date (format: yyyy-MM-dd), (or enter 0 to go back) : ")
        
        guard let dateString1 = readLine(), !dateString1.isEmpty else {
            print("Invalid input.")
            return
        }
        
        if dateString1 == "0" {
            print("----------------------------------------------------------------")
              viewLogsEntry()
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date1 = dateFormatter.date(from: dateString1) else {
            print("Invalid date format. Please use yyyy-MM-dd.")
              viewLogsBetweenDates()
            return
        }
        
        print("----------------------------------------------------------------")
        print("Enter the End Date (format: yyyy-MM-dd), (or enter 0 to go back) : ")
        
        guard let dateString2 = readLine(), !dateString2.isEmpty else {
            print("Invalid input.")
            return
        }
        
        if dateString2 == "0" {
            print("----------------------------------------------------------------")
              viewLogsEntry()
            return
        }
        
        guard let date2 = dateFormatter.date(from: dateString2) else {
            print("Invalid date format. Please use yyyy-MM-dd.")
              viewLogsBetweenDates()
            return
        }
        
        do {
            print("-----------------------------------------------------------------------------------")
            guard let dataEntries = try   adminController?.getLogsEntryBetweenDates(date1: date1, date2: date2), !dataEntries.isEmpty else {
                print("No entries found between the provided dates.")
                  viewLogsEntry()
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            
            print("                                   Log Entries                                    ")
            
            for entry in dataEntries {
                print("-----------------------------------------------------------------------------------")
                let formattedDate = dateFormatter.string(from: entry.getTimestamp)
                print("Entry ID           : \(entry.getId)")
                print("Entry Created Date : \(formattedDate)")
                print("Entry Message      : \(entry.messageProperty)")
            }
            print("-----------------------------------------------------------------------------------")
        } catch let error {
            print("Error while reading logs : \(error.localizedDescription)")
            print("-----------------------------------------------------------------------------------")
        }
        
        print("Type 0 to return to the main menu or press any key to view logs for another date range:")
        if let input = readLine(), input == "0" {
            print("-----------------------------------------------------------------------------------")
              viewLogsEntry()
        } else {
              viewLogsBetweenDates()
        }
    }

    private func viewAllLogs()   {
        do {
            print("-----------------------------------------------------------------------------------")
            guard let dataEntries = try   adminController?.getAllLogsEntry() else {
                print("No entries found.")
                return
            }
            if dataEntries.isEmpty {
                print("No Logs Available for the Given Date..")
                  viewLogsEntry()
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            
            print("                                   Log Entries                                    ")
            
            for entry in dataEntries {
                print("-----------------------------------------------------------------------------------")
                let formattedDate = dateFormatter.string(from: entry.getTimestamp)
                print("Entry ID           : \(entry.getId)")
                print("Entry Created Date : \(formattedDate)")
                print("Entry Message      : \(entry.messageProperty)")
            }
            print("-----------------------------------------------------------------------------------")
        } catch let error {
            print("Error while reading logs : \(error.localizedDescription)")
            print("----------------------------------------------------------------")
        }
        
        print("Type 0 to return to the main menu or press any key to refresh and view all logs again:")
        if let input = readLine(), input == "0" {
            print("----------------------------------------------------------------")
              viewLogsEntry()
        } else {
            print("----------------------------------------------------------------")
              viewAllLogs()
        }
    }
    
    func setDefaultpassword(passwordState : Bool, adminId : Int)  throws {
        try   adminController?.setDefaultpassword(passwordState : false, adminId : adminId)
    }
}
