//
//  AgentDAOImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 27/11/24.
//
import SQLite3
import Foundation

class AgentDAOImpl : AgentDAO {
    
    let dbConnector = DatabaseManager.shared.db
    
    init() {
        do {
            try createTable()
        } catch let error {
            print("Error during table creation: \(error)")
        }
    }

    internal func createTable() throws {
        if sqlite3_exec(dbConnector, Queries.createAgentTable, nil, nil, nil) != SQLITE_OK {
            throw DatabaseError.tableCreationFailed("Users table creation failed. Error: \(String(cString: sqlite3_errmsg(dbConnector)))")
        }
        print("Agent table created successfully (or already exists).")
    }
    
    func addAgent(agent: Agent) -> Result<Void, DatabaseError>{
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(dbConnector, Queries.addAgent, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare INSERT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        print("userId : \(agent.getUserId)")
        sqlite3_bind_text(statement, 1, (agent.departmentProperty as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, ("available" as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 3, Int32(agent.getUserId))
        sqlite3_bind_text(statement, 4, (agent.getName as NSString).utf8String, -1, nil)

        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_finalize(statement)
            return .success(())
        } else {
            sqlite3_finalize(statement)
            return .failure(.executionFailed("Failed to insert Agent . Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
    }
    
    func updateAgentAvailability(agent: Agent, status: AgentStatus) -> Result<Void, DatabaseError> {
        let query = Queries.updateAgentAvailability
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare UPDATE statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        sqlite3_bind_text(statement, 1, (status.rawValue as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 2, Int32(agent.getAgentId))
        
        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_finalize(statement)
            return .success(())
        } else {
            sqlite3_finalize(statement)
            return .failure(.executionFailed("Failed to update Avaialability. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
    }
    
    func changePassword(agent: Agent, newPassword: String)-> Result<Void, DatabaseError> {
        let query = Queries.updatePassword
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare UPDATE statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }

        sqlite3_bind_text(statement, 1, (newPassword as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 2, Int32(agent.getUserId))

        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_finalize(statement)
            return .success(())
        } else {
            sqlite3_finalize(statement)
            return .failure(.executionFailed("Failed to update password. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
    }
    
    func getAgentById(agentId: Int) -> Result<Agent, DatabaseError> {
        let query = Queries.getAgentById
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }

        sqlite3_bind_int(statement, 1, Int32(agentId))
        
        if sqlite3_step(statement) == SQLITE_ROW {
            let agentId = Int(sqlite3_column_int(statement, 0))
            let department = String(cString: sqlite3_column_text(statement, 1))
            let availabiltyStatus = String(cString: sqlite3_column_text(statement, 2))
            let ticketResolvedCount = Int(sqlite3_column_int(statement, 3))
            let userId = Int(sqlite3_column_int(statement, 4))
            let name = String(cString: sqlite3_column_text(statement, 5))
            sqlite3_finalize(statement)
            return .success(Agent(id: agentId, name: name, department: department, status: AgentStatus(rawValue: availabiltyStatus) ?? AgentStatus.available, ticketResolved: ticketResolvedCount, userId: userId))
        } else {
            sqlite3_finalize(statement)
            return .failure(.noRecordFound("No agent found for agent with ID \(agentId)."))
        }
    }
    
    func getAllAgents() -> Result<[Agent], DatabaseError>  {
        let query = Queries.getAllAgents
        var statement: OpaquePointer?
        var agents: [Agent] = []

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }

        while sqlite3_step(statement) == SQLITE_ROW {
            let agentId = Int(sqlite3_column_int(statement, 0))
            let department = String(cString: sqlite3_column_text(statement, 1))
            let availabiltyStatus = String(cString: sqlite3_column_text(statement, 2))
            let ticketResolvedCount = Int(sqlite3_column_int(statement, 3))
            let userId = Int(sqlite3_column_int(statement, 4))
            let name = String(cString: sqlite3_column_text(statement, 5))
            let status = AgentStatus(rawValue: availabiltyStatus) ?? AgentStatus.available
            let newAgent = Agent(id: agentId, name: name, department: department, status: status, ticketResolved: ticketResolvedCount, userId: userId)
            agents.append(newAgent)
        }

        sqlite3_finalize(statement)
        return .success(agents)
    }
    
    func addTicketToAgent(agent: Agent, ticket: Ticket) -> Result<Void, DatabaseError> {
        let query = Queries.addTicketToAgent
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        
        sqlite3_bind_int(statement, 1, Int32(ticket.getTicketId))
        sqlite3_bind_int(statement, 2, Int32(agent.getAgentId))

        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_finalize(statement)
            return .success(())
        } else {
            sqlite3_finalize(statement)
            return .failure(.executionFailed("Failed to add ticket to agent. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
    }
    
    func assignAgentToTicket(agentId: Int, ticketId: Int) -> Result<Void, DatabaseError> {
        let query = Queries.assignAgentToTicket
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare UPDATE statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        
        sqlite3_bind_int(statement, 1, Int32(agentId))
        sqlite3_bind_int(statement, 2, Int32(ticketId))
        
        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_finalize(statement)
            return .success(())
        } else {
            sqlite3_finalize(statement)
            return .failure(.executionFailed("Failed to update ticket. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
    }

    
    func addAgentUserNamePassword(userName : String, password : String, agent : Agent) -> Result<Void, DatabaseError>  {
        let query = Queries.addUserNameAndPassword
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        
        sqlite3_bind_text(statement, 1, (userName as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, (password as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 3, Int32(agent.getUserId))

        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_finalize(statement)
            return .success(())
        } else {
            sqlite3_finalize(statement)
            return .failure(.executionFailed("Failed to insert Agent. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
    }
    
    func getUserNameAndPassword (userId : Int) -> Result<[String], DatabaseError> {
        let query = Queries.getUserNameAndPassword
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        sqlite3_bind_int(statement, 1, Int32(userId))
        
        if sqlite3_step(statement) == SQLITE_ROW {
            let userName = String(cString: sqlite3_column_text(statement, 0))
            let password = String(cString: sqlite3_column_text(statement, 1))
            sqlite3_finalize(statement)
            return .success([userName, password])
        } else {
            sqlite3_finalize(statement)
            return .failure(.noRecordFound("No user found for user with ID \(userId)."))
        }
    }
    
    func updateTicketsResolvedCount(agentId: Int, newCount: Int) -> Result<Void, DatabaseError> {
        let query = Queries.updateTicketResolvedCount
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare UPDATE statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        
        sqlite3_bind_int(statement, 1, CInt(newCount))
        sqlite3_bind_int(statement, 2, CInt(agentId))
        
        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_finalize(statement)
            return .success(())
        } else {
            sqlite3_finalize(statement)
            return .failure(.executionFailed("Failed to execute UPDATE statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
    }

}
