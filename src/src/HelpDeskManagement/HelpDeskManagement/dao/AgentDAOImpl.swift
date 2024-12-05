//
//  AgentDAOImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 27/11/24.
//
import Foundation

class AgentDAOImpl : AgentDAO {
    
    
    var dataBase : DataBase
    init(dataBase : DataBase) {
        self.dataBase = dataBase
        do{
            try dataBase.createTable(createTableQuery: Queries.createAgentTable)
        }
        catch {
            print("Error : \(error)")
        }
    }

    
    func addAgent(agent: Agent) -> Result<Void, DatabaseError>{
        let query = "INSERT INTO Agents (department, availabilityStatus, userId, name) values ( ?, ?, ?, ?)"
        let data : [Any] = [
            agent.departmentProperty,
            agent.statusProperty.rawValue,
            agent.getUserId,
            agent.getName
        ]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            return try dataBase.insertRecord(query: finalQuery)
        } catch let error as DatabaseError {
            return .failure(error)
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func updateAgentAvailability(agent: Agent, status: AgentStatus) -> Result<Void, DatabaseError> {
        let query = "UPDATE Agents SET availabilityStatus = ? where agent_id = ?"
        let data : [Any] = [status.rawValue,agent.getAgentId]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            return try dataBase.insertRecord(query: finalQuery)
        } catch let error as DatabaseError {
            return .failure(error)
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func changePassword(agent: Agent, newPassword: String)-> Result<Void, DatabaseError> {
        let query = "UPDATE userNameAndPasswords SET password = ? where userId = ?;"
        let data : [Any] = [newPassword,agent.getUserId]
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            return try dataBase.insertRecord(query: finalQuery)
        } catch let error as DatabaseError {
            return .failure(error)
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func getAgentById(agentId: Int) -> Result<Agent, DatabaseError> {
        let query = "SELECT * from Agents WHERE agent_id = ?"
        let data : [Any] = [agentId]
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            let result = try dataBase.executeQueryData(query: finalQuery)
            switch result {
            case .success(let usersData):
                if let userDict = usersData.first,
                   let agentId = userDict["agent_id"] as? Int,
                         let department = userDict["department"] as? String,
                         let availabilityStatusString = userDict["availabilityStatus"] as? String,
                         let ticketResolvedCount = userDict["ticketsResolvedCount"] as? Int,
                         let userId = userDict["userId"] as? Int,
                         let name = userDict["name"] as? String,
                         let status = AgentStatus(rawValue: availabilityStatusString){
                    return .success(Agent(id: agentId, name: name, department: department, status: status, ticketResolved: ticketResolvedCount, userId: userId))
                } else {
                    return .failure(.executionFailed("Failed to extract user data."))
                }
                
            case .failure(let error):
                return .failure(error)
            }
            
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func getAllAgents() throws -> Result<[Agent], DatabaseError> {
        let query = "SELECT * FROM Agents"
        
        let result = try dataBase.executeQueryData(query: query)
        switch result {
        case .success(let usersData):
            let agents = usersData.compactMap { userDict -> Agent? in
                guard let agentId = userDict["agent_id"] as? Int,
                      let department = userDict["department"] as? String,
                      let availabilityStatusString = userDict["availabilityStatus"] as? String,
                      let ticketResolvedCount = userDict["ticketsResolvedCount"] as? Int,
                      let userId = userDict["userId"] as? Int,
                      let name = userDict["name"] as? String,
                      let status = AgentStatus(rawValue: availabilityStatusString)
                else {
                    print("Invalid row data: \(userDict)")
                    return nil
                }
                return Agent(
                    id: agentId,
                    name: name,
                    department: department,
                    status: status,
                    ticketResolved: ticketResolvedCount,
                    userId: userId
                )
            }
            
            return .success(agents)
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func addTicketToAgent(agent: Agent, ticket: Ticket) -> Result<Void, DatabaseError> {
        let query = "INSERT INTO AssignedTickets (ticketId, agentId) VALUES(?,?);"
        
        let data : [Any] = [
            ticket.getTicketId,
            agent.getAgentId
        ]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            return try dataBase.insertRecord(query: finalQuery)
        } catch let error as DatabaseError {
            return .failure(error)
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func assignAgentToTicket(agentId: Int, ticketId: Int) -> Result<Void, DatabaseError> {
        let query = "UPDATE Tickets SET agent_id = ? WHERE ticket_id = ?;"
        let data : [Any] = [agentId,ticketId]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            return try dataBase.insertRecord(query: finalQuery)
        } catch let error as DatabaseError {
            return .failure(error)
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func addAgentUserNamePassword(userName : String, password : String, agent : Agent) -> Result<Void, DatabaseError>  {
        let query = "INSERT INTO userNameAndPasswords (userName, password, userId) values (?,?,?);"
        let data: [Any] = [userName, password, agent.getUserId]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            
            let result: Result<Void, DatabaseError> = try dataBase.insertRecord(query: finalQuery)
            
            switch result {
            case .success:
                return .success(())
                
            case .failure(let error):
                return .failure(error)
            }
            
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func getUserNameAndPassword (userId : Int) -> Result<[String], DatabaseError> {
        let query = "SELECT userName, password FROM userNameAndPasswords WHERE userId = ?;"
        let data: [Any] = [userId]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            
            let result = try dataBase.executeQueryData(query: finalQuery)
            
            switch result {
            case .success(let usersData):
                let credentials = usersData.compactMap { userDict -> [String]? in
                    guard let userName = userDict["userName"] as? String,
                          let password = userDict["password"] as? String else {
                        return nil
                    }
                    return [userName, password]
                }
                
                return .success(credentials.flatMap { $0 })
                
            case .failure(let error):
                return .failure(error)
            }
            
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func updateTicketsResolvedCount(agentId: Int, newCount: Int) -> Result<Void, DatabaseError> {
        let query = "UPDATE Agents SET ticketsResolvedCount = ? WHERE agent_id = ?"
        let data : [Any] = [newCount,agentId]
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            return try dataBase.insertRecord(query: finalQuery)
        } catch let error as DatabaseError {
            return .failure(error)
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }

}
