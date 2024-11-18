//
//  AgentController.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//

protocol AgentController : AnyObject{
    func checkAgentAvailability(agentId : Int) -> AgentStatus
    func updateAgentAvailability(agent : Agent, status : AgentStatus) -> Bool
    func trackAgentPerfomance(agentId : Int) -> AgentPerfomance?
    func getAgentById(agentId : Int) -> Agent?
    func setTicketController(ticketController : TicketController)
    func setUserController(userController : UserController)
    func setKnowledgeBaseController(knowledgeBaseController : KnowledgeBaseController)
    func addAgent(name : String, department : String, userName : String, password : String)
    func changePassword(agent: Agent, newPassword : String) -> Bool
}
