//
//  AdminView.swift
//  HelpDeskManagement
//
//  Created by incubation on 07/11/24.
//
import Foundation

struct AdminView {
    private var ticketController : TicketController?
    private var reportGenerator : ReportAndAnalyticsController?
    private var agentController : AgentController?
    //private lazy var mainView = MainView()
    
    mutating func setTicketController(ticketController : TicketControllerImpl) {
        self.ticketController = ticketController
    }
    mutating func setAgentController(agentController : AgentControllerImpl) {
        self.agentController = agentController
    }
    mutating func setReportAndAnalyticsController(reportAndAnalyticsController : ReportAndAnalyticsControllerImpl) {
        self.reportGenerator = reportAndAnalyticsController
    }
    func adminMenu() {
        
        print(" ==== Admin Dashboard ==== ")
        print("1. Add Agent")
        print("2. View All Agents and Workloads")
        print("3. View Tickets by Status ")
        print("4. Generate Ticket Reports")
        print("5. Generate Agent Reports")
        print("6. Escalate/Reassign Tickets")
        print("7. Logout")
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
            mainView.showLoginScreen()
        default :
            print("Invalid Option")
        }
    }
    
    func viewAllAgents() {
        let allAgents = DataStorage.allAgents
        print(allAgents)
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
    
    func addAgent() {
        print("Enter the Agent's Name")
        let agentName = readLine()!
        if !Validation.validateName(agentName) {
            print("Plese Enter Valid Name")
        }
        print("Enter Agent's Department")
        let agentDepartMent = readLine()!
        if !Validation.validateName(agentDepartMent) {
            print("Plese Enter Valid Department")
        }
        print("Enter Agent's UserName")
        let agentUserName = readLine()!
        if !Validation.validateUsername(agentUserName) {
            print("Plese Enter Valid User Name")
        }
        print("Enter Agent's Password")
        let agentPassword = readLine()!
        if !Validation.validatePassword(agentPassword) {
            print("Plese Enter Valid Password")
        }
        
        agentController?.addAgent(name: agentName, department: agentDepartMent, userName: agentUserName, password: agentPassword)
        print("Agent Added successfully")
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
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else {
            print("Invalid date format. Please use yyyy-MM-dd.")
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
        
        print("Enter the Old Agent id ")
        guard let oldAgentId = Int(readLine()!) else {
            print("Invalid Agent ID.")
            return
        }
        print("Enter the ticket ID :")
        guard let ticketId = Int(readLine()!) else {
            print("Invalid ticket ID.")
            return
        }
        
        print("Enter the Agent ID:")
        guard let agentId = Int(readLine()!) else {
            print("Invalid Agent ID.")
            return
        }
        let result = (ticketController?.reassignTicket(ticketId: ticketId, agentId: agentId, oldAgentid: oldAgentId))!
        if result {
            print("Ticket Successfully Reassigned")
            adminMenu()
            return
        }
        print("Ticket Not Reassigned")
        adminMenu()
    }
}
