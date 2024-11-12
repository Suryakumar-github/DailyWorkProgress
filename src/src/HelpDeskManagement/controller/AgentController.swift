//
//  AgentController.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//

protocol AgentController {
    func checkAgentAvailability(agentId : Int) -> AgentStatus
    func assignTicketToAgent(ticket : Ticket) -> Bool
    func updateAgentAvailability(agentId : Int, status : AgentStatus) -> Bool
    func resolveTicket(ticketId : Int, userId : Int)
    func trackAgentPerfomance(agentId : Int) -> AgentPerfomance?
    func getAgentById(agentId : Int) -> Agent?
    func setTicketController(ticketController : TicketController)
    func setUserController(userController : UserController)
    func setKnowledgeBaseController(knowledgeBaseController : KnowledgeBaseController)
    func addAgent(name : String, department : String, userName : String, password : String) 
}
