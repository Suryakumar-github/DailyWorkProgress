//
//  ReportAndAnalyticsControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//
import Foundation

class ReportAndAnalyticsControllerImpl : ReportAndAnalyticsController {
    
    private var ticketController : TicketController?
    private var agentController : AgentController?
    
    func setTicketController(ticketController: TicketController) {
        self.ticketController = ticketController
    }
    
    func setAgentController(agentController : AgentController) {
        self.agentController = agentController
    }
    
    func generateTicketReport(date: Date) throws -> [Ticket]{
        guard let tickets = try ticketController?.getTicketByDate(date: date) else {
            print("No tickets found for the specified date.")
            return []
        }
        
        return tickets
    }

    func generateAgentreport(agentId: Int) throws -> Agent?{
        guard let agent = try agentController?.getAgentById(agentId: agentId) else {
            print("Agent not found.")
            return nil
        }
        return agent
        
    }
       
    deinit{
        
    }
}
