//
//  AgentController.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//

import Foundation

protocol AgentController : AnyObject{
    
    func checkAgentAvailability(agentId: Int)throws -> AgentStatus
    func updateAgentAvailability(agent : Agent, status : AgentStatus)throws -> Bool
    func getAgentById(agentId : Int)throws -> Agent?
    func setTicketController(ticketController : TicketController)
    func setKnowledgeBaseController(knowledgeBaseController : KnowledgeBaseController)
    func setLogsEntryController(logsEntryController: LogsEntryController)
    func addAgent(name : String, department : String, userName : String, password : String)throws
    func changePassword(agent : Agent, newPassword: String, currentPassword: String)throws -> Bool
    func closeTicket(agent: Agent, ticketId: Int, solution : String) throws -> Bool
    func fetchAssignedTickets(agent: Agent) throws -> [Ticket]
    func updateTicketStatus(agent : Agent, ticketId: Int, status: TicketStatus) throws -> Bool
    func addEntry(title: String, issueType : IssueType, solution: String, createdDate: Date, lastUpdatedDate: Date?, userId : Int)throws
    func search(word: String) throws -> [KnowledgeBase]
    func assignTicketToAgent(ticket: Ticket) throws -> Bool
    func getAllAgents() throws -> [Agent]
    func reAssignTicketToAgent(ticket: Ticket, agent : Agent) throws
}
