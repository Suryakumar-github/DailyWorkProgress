//
//  AdminControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 21/11/24.
//

import Foundation

class AdminControllerImpl: AdminController {
    
    private var ticketController: TicketController?
    private var reportGenerator: ReportAndAnalyticsController?
    private var agentController: AgentController?
    private var adminDao: AdminDAO
    private var logsEntryDao: LogsEntryDAO
    
    init()  {
        self.adminDao =  AdminDAOImpl()
        self.logsEntryDao =  LogsEntryDAOImpl()
    }

    func setTicketController(ticketController : TicketController) {
        self.ticketController = ticketController
    }
    
    func setAgentController(agentController : AgentController) {
        self.agentController = agentController
    }
    
    func setReportAndAnalyticsController(reportAndAnalyticsController : ReportAndAnalyticsController) {
        self.reportGenerator = reportAndAnalyticsController
    }
    
    func addAgent(name: String, department: String, userName: String, password: String) throws {
        try  agentController?.addAgent(name: name, department: department, userName: userName, password: password)
    }
    
    func generateTicketReport(date: Date)  throws -> [Ticket] {
        guard let tickets = try  reportGenerator?.generateTicketReport(date: date) else {
            return []
        }
        return tickets
    }
    
    func generateAgentreport(agentId: Int)  throws -> Agent? {
        guard let agent = try  reportGenerator?.generateAgentreport(agentId: agentId) else {
            return nil
        }
        return agent
    }
    
    func reassignTicket(ticketId: Int, agentId: Int)  throws -> Bool {
        if let controller = ticketController, try  controller.reassignTicket(ticketId: ticketId, agentId: agentId) {
            return true
        }
        return false
    }
    
    func updatePassword(user: Admin, newPassword: String, currentPassword : String)  throws -> Bool {
        
        let result =  adminDao.getUserNameAndPassword(userId: user.getId)
        switch result {
        case .success(let credentials) :
             let storedPassword = credentials[1]

            if storedPassword != currentPassword {
                print("Current password is incorrect.")
                return false
            }

            if storedPassword == newPassword {
                return false
            }
            
            let result =  adminDao.updatePassword(user: user, password: newPassword)
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
    
    func getAllAgents()  throws -> [Agent]? {
        return try  agentController?.getAllAgents()
    }
    
    func getAllTickets()  throws -> [Ticket] {
        return try  ticketController?.getAllCreatedTickets() ?? []
    }
    
    func getAgentTickets(agent : Agent)  throws -> [Ticket]? {
        guard let tickets = try  ticketController?.fetchAssignedTickets(agent: agent) else {
            return []
        }
        
        return tickets.filter { ticket in
            ticket.statusProperty != .cancelled && ticket.statusProperty != .closed
        }
    }
    
    func getAllLogsEntry()  throws -> [LogsEntry] {
        let result = try  logsEntryDao.getAllLogsEntry()
        switch result {
        case .success(let logsEntry) :
            return logsEntry
        case .failure(let error) :
            throw error
        }
    }
    
    func formatDateForDisplay(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    
    func setDefaultpassword(passwordState : Bool,adminId : Int) throws {
        let result =  adminDao.setDefaultpassword(passwordState: passwordState, adminId: adminId)
        switch result {
        case .success() :
            print("Password Updated")
        case .failure(let error) :
            throw error
        }
    }
    
    func fetchAssignedTickets(agent: Agent)  throws-> [Ticket] {
        return try  ticketController?.fetchAssignedTickets(agent: agent) ?? []
    }
    
    func getLogsEntryByDate(date: Date) throws -> [LogsEntry] {
        let result = try  logsEntryDao.getLogsEntryByDate(date: date)
        switch result {
        case .success(let logs) :
            return logs
            
        case .failure(let error) :
            throw error
        }
    }
    
    func getLogsEntryBetweenDates(date1: Date, date2: Date)  throws -> [LogsEntry] {
        let result = try  logsEntryDao.getLogsEntryBetweenDates(date1: date1, date2: date2)
        switch result {
        case .success(let logs) :
            return logs
            
        case .failure(let error) :
            throw error
        }
    }
    
    func getTicketByDate(date: Date)  throws -> [Ticket] {
        return try  ticketController?.getTicketByDate(date: date) ?? []
    }
    
    func getTicketsBetweendates(date1 : Date, date2 : Date)  throws -> [Ticket] {
        guard let tickets =  try  ticketController?.getTicketsBetweendates(date1: date1, date2: date2) else {
            return []
        }
        return tickets
    }
}
