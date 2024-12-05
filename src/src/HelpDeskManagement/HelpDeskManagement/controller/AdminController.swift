//
//  AdminController.swift
//  HelpDeskManagement
//
//  Created by incubation on 21/11/24.
//

import Foundation

protocol AdminController : AnyObject {
    func addAgent(name : String, department : String, userName : String, password : String)throws
    func generateTicketReport(date: Date) throws -> [Ticket]
    func generateAgentreport(agentId : Int) throws -> Agent?
    func reassignTicket(ticketId: Int, agentId : Int) throws-> Bool
    func updatePassword(user: Admin, newPassword: String, currentPassword : String) throws -> Bool
    func setTicketController(ticketController : TicketController)
    func setAgentController(agentController : AgentController)
    func setReportAndAnalyticsController(reportAndAnalyticsController : ReportAndAnalyticsController)
    func getAllAgents() throws -> [Agent]?
    func getAllTickets() throws -> [Ticket]
    func getAgentTickets(agent : Agent) throws -> [Ticket]?
    func getAllLogsEntry() throws -> [LogsEntry]
    func formatDateForDisplay(_ date: Date) -> String
    func setDefaultpassword(passwordState : Bool,adminId : Int)throws
    func fetchAssignedTickets(agent: Agent) throws -> [Ticket]
    func getLogsEntryByDate(date: Date) throws -> [LogsEntry]
    func getLogsEntryBetweenDates(date1: Date, date2: Date) throws -> [LogsEntry]
    func getTicketByDate(date: Date) throws -> [Ticket]
    func getTicketsBetweendates(date1 : Date, date2 : Date) throws -> [Ticket]
}
