//
//  ReportAndAnalyticsControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//
import Foundation

class ReportAndAnalyticsControllerImpl : ReportAndAnalyticsController {
    
    var ticketController : TicketController?
    var agentController : AgentController?
    
    func setTicketController(ticketController: TicketController) {
        self.ticketController = ticketController
    }
    func setAgentController(agentController : AgentController) {
        self.agentController = agentController
    }
    
    func generateTicketReport(date: Date) {
        let tickets = ticketController?.getTicketByDate(date: date)
        let totalTickets = tickets?.count
        let openedTickets = tickets?.filter({ $0.statusProperty == .opened })
        let solvedTickets = tickets?.filter({ $0.statusProperty == .solved  })
        let closedTickets = tickets?.filter({ $0.statusProperty == .closed })
        let holdedTickets = tickets?.filter({ $0.statusProperty == .onHold })
        let canceledTickets = tickets?.filter({ $0.statusProperty == .cancelled  })
        
        print("Total Tickets Created \(String(describing: totalTickets))")
        print("Opened Tickets Count : \(String(describing: openedTickets))")
        print("Solved Tickets Count : \(String(describing: solvedTickets))")
        print("Closed Tickets Count : \(String(describing: closedTickets))")
        print("Holded Tickets Count : \(String(describing: holdedTickets))")
        print("Canceled Tickets Count : \(String(describing: canceledTickets))")
    }
    
    func generateAgentreport(agentId: Int) {
        let agent = agentController?.getAgentById(agentId: agentId)
        let agentName = agent?.getName
        let assignedTicketsCount = agent?.assignedTicketsProperty.count
        let solvedTicketsCount = agent?.ticketResolvedProperty
        let agentPerfomance = agent?.perfomanceProperty
        
        print("Agent Name : \(String(describing: agentName))")
        print("Assigned Tickets Count : \(String(describing: assignedTicketsCount))")
        print("Solved Tickets Count : \(String(describing: solvedTicketsCount))")
        print("Agent Perfomance : \(String(describing: agentPerfomance))")
    }
        
}
