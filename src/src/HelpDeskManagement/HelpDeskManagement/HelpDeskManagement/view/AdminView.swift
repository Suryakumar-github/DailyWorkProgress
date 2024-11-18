//
//  AdminView.swift
//  HelpDeskManagement
//
//  Created by incubation on 07/11/24.
//
import Foundation

struct AdminView {
    private weak var ticketController : TicketController?
    private weak var reportGenerator : ReportAndAnalyticsController?
    private weak var agentController : AgentController?
    private var loginedUser : User?
    
    mutating func setTicketController(ticketController : TicketControllerImpl) {
        self.ticketController = ticketController
    }
    mutating func setAgentController(agentController : AgentControllerImpl) {
        self.agentController = agentController
    }
    mutating func setReportAndAnalyticsController(reportAndAnalyticsController : ReportAndAnalyticsControllerImpl) {
        self.reportGenerator = reportAndAnalyticsController
    }
    mutating func setLoginedUser(user : User) {
        self.loginedUser = user
    }
    
    func adminMenu() {
        
        print(" ==== Admin Dashboard ==== ")
        print("1. Add Agent")
        print("2. View All Agents and Workloads")
        print("3. View Tickets by Status ")
        print("4. Generate Ticket Reports")
        print("5. Generate Agent Reports")
        print("6. Escalate/Reassign Tickets")
        print("7. View Logs Entry")
        print("8. View Agent Perfomance")
        print("9. Logout")
        print("Select an option: ")
        let option = Int(readLine()!)
        
        switch option {
            
        case 1 :
            addAgent()
        case 2 :
            viewAllAgents()
        case 3 :
            viewTicketStatus()
        case 4 :
            generateTicketReport()
        case 5 :
            generateAgentReport()
        case 6 :
            reassignTicket()
        case 7 :
            viewLogsEntry()
        case 8:
            viewAgentPerfomance()
        case 9 :
            mainView.showLoginScreen()
        default :
            print("Invalid Option")
            adminMenu()
        }
    }
    
    func viewAllAgents() {
        let allAgents = DataStorage.allAgents
        print("-------------------------------------------")
        for (_, agent) in allAgents {
            print("-------------------------------------------")
                print("Agent Id : \(String(describing: agent.getId))")
                print("Agent Name : \(String(describing: agent.getName))")
                print("Agent Department : \(String(describing: agent.departmentProperty))")
            }
        print("-------------------------------------------")
        adminMenu()
    }
    
    func viewAgentPerfomance() {
        print("Enter the Agent ID:")
        guard let agentId = Int(readLine()!) else {
            print("Invalid ticket ID.")
            viewAgentPerfomance()
            return
        }
        guard let agentPerfomance = agentController?.trackAgentPerfomance(agentId: agentId) else {
            print("There is no Agent Present with AgentId : \(agentId)")
            viewAgentPerfomance()
            return
        }
        print("Agents Perfomace For AgentId \(agentId) : \(String(describing: agentPerfomance))")
        adminMenu()
    }
    
    func addAgent() {
        var agentName: String?
        var agentDepartment: String?
        var agentUserName: String?
        var agentPassword: String?
        
        while agentName == nil || agentDepartment == nil || agentUserName == nil || agentPassword == nil {
            if agentName == nil {
                print("Enter the Agent's Name:")
                let inputName = readLine()!
                if Validation.validateName(inputName) {
                    agentName = inputName
                } else {
                    print("Please enter a valid name.")
                    continue
                }
            }
            
            if agentDepartment == nil {
                print("Enter Agent's Department:")
                let inputDepartment = readLine()!
                if Validation.validateName(inputDepartment) {
                    agentDepartment = inputDepartment
                } else {
                    print("Please enter a valid department.")
                    continue
                }
            }
            
            if agentUserName == nil {
                print("Enter Agent's UserName:")
                let inputUserName = readLine()!
                if Validation.validateUsername(inputUserName) {
                    agentUserName = inputUserName
                } else {
                    print("Please enter a valid username.")
                    continue
                }
            }
            
            if agentPassword == nil {
                print("Enter Agent's Password:")
                let inputPassword = readLine()!
                if Validation.validatePassword(inputPassword) {
                    agentPassword = inputPassword
                } else {
                    print("Please enter a valid password.")
                    continue
                }
            }
        }
        
        agentController?.addAgent(name: agentName!, department: agentDepartment!, userName: agentUserName!, password: agentPassword!)
        print("Agent added successfully")
        adminMenu()
    }
    
    func viewTicketStatus() {
        print("Enter the ticket ID:")
        guard let ticketId = Int(readLine()!) else {
            print("Invalid ticket ID.")
            return
        }
        let ticket = ticketController?.getTicketById(ticketId: ticketId)
        print("Ticket Status : \(String(describing: ticket?.statusProperty))")
        adminMenu()
    }
    
    func generateTicketReport() {
        print("Enter the Date to Generate Report (format: yyyy-MM-dd):")
        
        guard let dateString = readLine(), !dateString.isEmpty else {
            print("Invalid date input.")
            generateTicketReport()
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else {
            print("Invalid date format. Please use yyyy-MM-dd.")
            generateTicketReport()
            return
        }
        
        let ticketReport: () = (reportGenerator?.generateTicketReport(date: date))!
        print("Report generated for \(dateString): \(ticketReport)")
        adminMenu()
    }

    func generateAgentReport() {
        print("Enter the Agent ID:")
        guard let agentId = Int(readLine()!) else {
            print("Invalid ticket ID.")
            return
        }
        let _: () = (reportGenerator?.generateAgentreport(agentId: agentId))!
        
        adminMenu()
    }
    
    func reassignTicket() {
        var oldAgentId: Int?
        var ticketId: Int?
        var newAgentId: Int?

        while oldAgentId == nil || ticketId == nil || newAgentId == nil {
            if oldAgentId == nil {
                print("Enter the Old Agent ID:")
                if let input = Int(readLine()!) {
                    oldAgentId = input
                } else {
                    print("Invalid Agent ID. Please enter a valid integer.")
                    continue
                }
            }
            
            if ticketId == nil {
                print("Enter the Ticket ID:")
                if let input = Int(readLine()!) {
                    ticketId = input
                } else {
                    print("Invalid Ticket ID. Please enter a valid integer.")
                    continue
                }
            }
            
            if newAgentId == nil {
                print("Enter the New Agent ID:")
                if let input = Int(readLine()!) {
                    newAgentId = input
                } else {
                    print("Invalid Agent ID. Please enter a valid integer.")
                    continue
                }
            }
        }
        
        if let ticketController = ticketController, ticketController.reassignTicket(ticketId: ticketId!, agentId: newAgentId!, oldAgentid: oldAgentId!) {
            print("Ticket successfully reassigned")
        } else {
            print("Ticket not reassigned")
        }
        
        adminMenu()
    }

    func viewLogsEntry() {
       let dataEntries = DataStorage.allLogsEntry
        print("---------------Log Entries------------------")
        for (_,entry) in dataEntries {
            print("---------------------------------------------")
            print("Entry id : \(entry.getId)")
            print("Entry Created Date : \(entry.getTimestamp)")
            print("Entry Message : \(entry.messageProperty)")
        }
        print("---------------------------------------------")
        adminMenu()
    }
}
