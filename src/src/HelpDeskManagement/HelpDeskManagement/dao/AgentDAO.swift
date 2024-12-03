//
//  AgentDAO.swift
//  HelpDeskManagement
//
//  Created by incubation on 26/11/24.
//

protocol AgentDAO {
    func addAgent(agent : Agent) -> Result<Void, DatabaseError>
    func updateAgentAvailability(agent: Agent, status: AgentStatus) -> Result<Void, DatabaseError>
    func changePassword(agent : Agent, newPassword: String) -> Result<Void, DatabaseError>
    func getAgentById(agentId: Int) -> Result<Agent, DatabaseError>
    func getAllAgents() -> Result<[Agent], DatabaseError>
    func addTicketToAgent(agent : Agent, ticket : Ticket) -> Result<Void, DatabaseError>
    func addAgentUserNamePassword(userName : String, password : String, agent : Agent) -> Result<Void, DatabaseError>
    func getUserNameAndPassword (userId : Int) -> Result<[String], DatabaseError>
    func assignAgentToTicket(agentId: Int, ticketId: Int) -> Result<Void, DatabaseError>
    func updateTicketsResolvedCount(agentId: Int, newCount: Int) -> Result<Void, DatabaseError> 
}
