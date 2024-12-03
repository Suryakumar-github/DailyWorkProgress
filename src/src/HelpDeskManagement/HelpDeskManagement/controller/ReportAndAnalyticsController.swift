//
//  ReportAndAnalyticsController.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//
import Foundation

protocol ReportAndAnalyticsController : AnyObject{
    func generateTicketReport(date : Date) throws -> [Ticket]
    func generateAgentreport(agentId : Int) throws -> Agent?
    func setTicketController(ticketController: TicketController)
    func setAgentController(agentController : AgentController)
}
