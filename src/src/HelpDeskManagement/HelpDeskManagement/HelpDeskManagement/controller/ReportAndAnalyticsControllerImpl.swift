//
//  ReportAndAnalyticsControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//
import Foundation

class ReportAndAnalyticsControllerImpl : ReportAndAnalyticsController {
    
    private weak var ticketController : TicketController?
    private weak var agentController : AgentController?
    
    func setTicketController(ticketController: TicketController) {
        self.ticketController = ticketController
    }
    func setAgentController(agentController : AgentController) {
        self.agentController = agentController
    }
    
    func generateTicketReport(date: Date) {
        guard let tickets = ticketController?.getTicketByDate(date: date) else {
            print("No tickets found for the specified date.")
            return
        }
        
        let totalTickets = tickets.count
        let openedTickets = tickets.filter { $0.statusProperty == .opened }.count
        let solvedTickets = tickets.filter { $0.statusProperty == .solved }.count
        let closedTickets = tickets.filter { $0.statusProperty == .closed }.count
        let holdedTickets = tickets.filter { $0.statusProperty == .onHold }.count
        let canceledTickets = tickets.filter { $0.statusProperty == .cancelled }.count
        
        print("------------------------Agent Report------------------------")
        print("Total Tickets Created: \(totalTickets)")
        print("Opened Tickets Count: \(openedTickets)")
        print("Solved Tickets Count: \(solvedTickets)")
        print("Closed Tickets Count: \(closedTickets)")
        print("Holded Tickets Count: \(holdedTickets)")
        print("Canceled Tickets Count: \(canceledTickets)")
        print("-------------------------------------------------------------")
    }

    
    func generateAgentreport(agentId: Int) {
        guard let agent = agentController?.getAgentById(agentId: agentId) else {
            print("Agent not found.")
            return
        }
        
        let agentName = agent.getName
        let assignedTicketsCount = agent.assignedTicketsProperty.count
        let solvedTicketsCount = agent.ticketResolvedProperty
        let agentPerformance = agent.perfomanceProperty ?? AgentPerfomance.Super
        
        print("------------------------Ticket Report--------------------------")
        print("Agent Name: \(agentName)")
        print("Assigned Tickets Count: \(assignedTicketsCount)")
        print("Solved Tickets Count: \(solvedTicketsCount)")
        print("Agent Performance: \(agentPerformance)")
        print("----------------------------------------------------------------")
    }
        
}
