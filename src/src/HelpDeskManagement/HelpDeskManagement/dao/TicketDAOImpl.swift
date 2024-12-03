import SQLite3
import Foundation


class TicketDAOImpl : TicketDAO{
    
    let dbConnector = DatabaseManager.shared.db
    
    init() {
        do {
            try createTable()
        } catch  {
            print("Ticket Table already exist in DataBase")
        }
    }
    
    private func createTable() throws {
        let createTableQuery = Queries.createTicketTable
        if sqlite3_exec(dbConnector, createTableQuery, nil, nil, nil) != SQLITE_OK {
            throw DatabaseError.tableCreationFailed("Tickets table creation failed. Error: \(String(cString: sqlite3_errmsg(dbConnector)))")
        }
        print("Tickets table created successfully (or already exists).")
    }
    
    func addTicket(ticket: Ticket) -> Result<Void, DatabaseError> {
        let query = Queries.addTicket
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare INSERT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        
        sqlite3_bind_text(statement, 1, (ticket.getTicketTitle as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, (ticket.descriptionproperty as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 3, Int32(ticket.getUserId))
        
        if let agentId = ticket.getAgentId {
            sqlite3_bind_int(statement, 4, Int32(agentId))
        } else {
            sqlite3_bind_null(statement, 4)
        }
        
        sqlite3_bind_int(statement, 5, Int32(ticket.priorityProperty?.rawValue ?? 1))
        sqlite3_bind_text(statement, 6, (ticket.statusProperty.rawValue as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 7, (ticket.getIssueType.rawValue as NSString).utf8String, -1, nil)
        
        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_finalize(statement)
            return .success(())
        } else {
            sqlite3_finalize(statement)
            return .failure(.executionFailed("Failed to insert ticket. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
    }
    
    func getAllTheCreatedTickets(user: User) -> Result<[Ticket], DatabaseError> {
        let query = Queries.getUserCreatedTickets
        var statement: OpaquePointer?
        var tickets: [Ticket] = []
        
        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        
        sqlite3_bind_int(statement, 1, Int32(user.getId))
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(statement, 0))
            let title = String(cString: sqlite3_column_text(statement, 1))
            let description = String(cString: sqlite3_column_text(statement, 2))
            let userId = Int(sqlite3_column_int(statement, 3))
            let agentId = Int(sqlite3_column_int(statement, 4))
            let priorityValue = Int(sqlite3_column_int(statement, 5))
            let statusRawValue = String(cString: sqlite3_column_text(statement, 6))
            let createdDateString = String(cString: sqlite3_column_text(statement, 7))
            let issueTypeRawValue = String(cString: sqlite3_column_text(statement, 8))
            
            let createdDate: Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: createdDateString) {
                createdDate = date
            } else {
                createdDate = Date()
            }
            
            guard let priority = Priority(rawValue: priorityValue) else {
                print("Invalid priority value: \(priorityValue)")
                continue
            }
            
            guard let status = TicketStatus(rawValue: statusRawValue) else {
                print("Invalid status value \(statusRawValue)")
                continue
            }
            
            let issueType = IssueType(rawValue: issueTypeRawValue) ?? .software
            
            let ticket = Ticket(
                id: id,
                title: title,
                description: description,
                createdDate: createdDate,
                status: status,
                userId: userId,
                agentId: agentId,
                issueType: issueType,
                priority: priority
            )
            
            tickets.append(ticket)
        }
        
        sqlite3_finalize(statement)
        
        return tickets.isEmpty ? .failure(.executionFailed("Failed to insert ticket. Error: \(String(cString: sqlite3_errmsg(dbConnector)))")): .success(tickets)
    }

    func updateTicketStatus(ticketId: Int, status: TicketStatus) -> Result<Void, DatabaseError> {
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(dbConnector, Queries.updateTicketStatus, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare UPDATE statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        
        guard let statusCString = status.rawValue.cString(using: .utf8) else {
            sqlite3_finalize(statement)
            return .failure(.executionFailed("Failed to convert status to C string."))
        }
        
        sqlite3_bind_text(statement, 1, statusCString, -1, nil)
        sqlite3_bind_int(statement, 2, Int32(ticketId))
        
        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_finalize(statement)
            return .success(())
        } else {
            sqlite3_finalize(statement)
            return .failure(.executionFailed("Failed to update ticket status. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
    }
    
    func findAgentByTicketId(ticketId: Int) -> Result<Agent?, DatabaseError> {
        let query = Queries.findAgentByTicketId
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        
        sqlite3_bind_int(statement, 1, Int32(ticketId))
        
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
            return .failure(.noRecordFound(" Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
    }
    
    func fetchAssignedTickets(agent: Agent) -> Result<[Ticket], DatabaseError> {
        let query = Queries.getAgentTickets
        
        var statement: OpaquePointer?
        var tickets: [Ticket] = []
        
        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        
        defer {
            sqlite3_finalize(statement)
        }
        
        sqlite3_bind_int(statement, 1, Int32(agent.getAgentId))
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(statement, 0))
            let title = String(cString: sqlite3_column_text(statement, 1))
            let description = String(cString: sqlite3_column_text(statement, 2))
            let userId = Int(sqlite3_column_int(statement, 3))
            let agentId = Int(sqlite3_column_int(statement, 4))
            let priorityValue = Int(sqlite3_column_int(statement, 5))
            let createdDateString = String(cString: sqlite3_column_text(statement, 6))
            let statusRawValue = String(cString: sqlite3_column_text(statement, 7))
            let issueTypeRawValue = String(cString: sqlite3_column_text(statement, 8))
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd "
            let createdDate = dateFormatter.date(from: createdDateString) ?? Date()
            
            guard let priority = Priority(rawValue: priorityValue) else {
                print("Invalid priority value: \(priorityValue)")
                continue
            }
            
            guard let status = TicketStatus(rawValue: statusRawValue) else {
                print("Invalid status value: \(statusRawValue)")
                continue
            }
            
            let issueType = IssueType(rawValue: issueTypeRawValue) ?? .software
            
            let ticket = Ticket(
                id: id,
                title: title,
                description: description,
                createdDate: createdDate,
                status: status,
                userId: userId,
                agentId: agentId,
                issueType: issueType,
                priority: priority
            )
            tickets.append(ticket)
        }
        
        if tickets.isEmpty {
            return .failure(.noRecordFound("No tickets found for agent ID \(agent.getAgentId)."))
        }
        
        return .success(tickets)
    }
    
    func getTicketById(ticketId: Int) -> Result<Ticket?, DatabaseError> {
        let query = Queries.getTicketById
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }

        sqlite3_bind_int(statement, 1, Int32(ticketId))

        if sqlite3_step(statement) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(statement, 0))
            let title = String(cString: sqlite3_column_text(statement, 1))
            let description = String(cString: sqlite3_column_text(statement, 2))
            let userId = Int(sqlite3_column_int(statement, 3))
            let agentId = sqlite3_column_type(statement, 4) != SQLITE_NULL ? Int(sqlite3_column_int(statement, 4)) : nil
            let priorityValue = Int(sqlite3_column_int(statement, 5))
            let statusRawValue = String(cString: sqlite3_column_text(statement, 6))
            let createdDateString = String(cString: sqlite3_column_text(statement, 7))
            let issueTypeRawValue = String(cString: sqlite3_column_text(statement, 8))

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let createdDate = dateFormatter.date(from: createdDateString) ?? Date()

            guard let priority = Priority(rawValue: priorityValue) else {
                sqlite3_finalize(statement)
                return .failure(.executionFailed("Invalid priority value: \(priorityValue)"))
            }

            guard let status = TicketStatus(rawValue: statusRawValue) else {
                sqlite3_finalize(statement)
                return .failure(.executionFailed("Invalid status value: \(statusRawValue)"))
            }

            let issueType = IssueType(rawValue: issueTypeRawValue) ?? .software

            let ticket = Ticket(
                id: id,
                title: title,
                description: description,
                createdDate: createdDate,
                status: status,
                userId: userId,
                agentId: agentId ?? 0,
                issueType: issueType,
                priority: priority
            )

            sqlite3_finalize(statement)
            return .success(ticket)
        }

        sqlite3_finalize(statement)
        return .failure(.executionFailed("Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
    }
    
    func getTicketByDate(date: Date) -> Result<[Ticket], DatabaseError> {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDateString = dateFormatter.string(from: date)

        let query = "SELECT * FROM Tickets WHERE DATE(created_at) = '\(formattedDateString)';"
        var statement: OpaquePointer?
        var tickets: [Ticket] = []

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }

        while sqlite3_step(statement) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(statement, 0))
            let title = String(cString: sqlite3_column_text(statement, 1))
            let description = String(cString: sqlite3_column_text(statement, 2))
            let userId = Int(sqlite3_column_int(statement, 3))
            let agentId = Int(sqlite3_column_int(statement, 4))
            let priorityValue = Int(sqlite3_column_int(statement, 5))
            let statusRawValue = String(cString: sqlite3_column_text(statement, 6))
            let createdDateString = String(cString: sqlite3_column_text(statement, 7))
            let issueTypeRawValue = String(cString: sqlite3_column_text(statement, 8))

            let createdDate: Date
            if let date = dateFormatter.date(from: createdDateString) {
                createdDate = date
            } else {
                createdDate = Date()
            }

            guard let priority = Priority(rawValue: priorityValue) else {
                print("Invalid priority value: \(priorityValue)")
                continue
            }

            guard let status = TicketStatus(rawValue: statusRawValue) else {
                continue
            }

            let issueType = IssueType(rawValue: issueTypeRawValue) ?? .software

            let ticket = Ticket(
                id: id,
                title: title,
                description: description,
                createdDate: createdDate,
                status: status,
                userId: userId,
                agentId: agentId,
                issueType: issueType,
                priority: priority
            )

            tickets.append(ticket)
        }

        sqlite3_finalize(statement)

        return tickets.isEmpty ? .failure(.noRecordFound("No tickets found for the given date.")) : .success(tickets)
    }
    
    func getTicketsBetweendates(date1 : Date, date2 : Date) -> Result<[Ticket], DatabaseError> {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let formattedDateString1 = dateFormatter1.string(from: date1)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        let formattedDateString2 = dateFormatter2.string(from: date2)

        let query = "SELECT * FROM Tickets WHERE DATE(created_at) BETWEEN '\(formattedDateString1)' AND '\(formattedDateString2)';"
        var statement: OpaquePointer?
        var tickets: [Ticket] = []

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }

        while sqlite3_step(statement) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(statement, 0))
            let title = String(cString: sqlite3_column_text(statement, 1))
            let description = String(cString: sqlite3_column_text(statement, 2))
            let userId = Int(sqlite3_column_int(statement, 3))
            let agentId = Int(sqlite3_column_int(statement, 4))
            let priorityValue = Int(sqlite3_column_int(statement, 5))
            let statusRawValue = String(cString: sqlite3_column_text(statement, 6))
            let createdDateString = String(cString: sqlite3_column_text(statement, 7))
            let issueTypeRawValue = String(cString: sqlite3_column_text(statement, 8))

            let createdDate: Date
            if let date = dateFormatter1.date(from: createdDateString) {
                createdDate = date
            } else {
                createdDate = Date()
            }

            guard let priority = Priority(rawValue: priorityValue) else {
                print("Invalid priority value: \(priorityValue)")
                continue
            }

            guard let status = TicketStatus(rawValue: statusRawValue) else {
                continue
            }

            let issueType = IssueType(rawValue: issueTypeRawValue) ?? .software

            let ticket = Ticket(
                id: id,
                title: title,
                description: description,
                createdDate: createdDate,
                status: status,
                userId: userId,
                agentId: agentId,
                issueType: issueType,
                priority: priority
            )

            tickets.append(ticket)
        }

        sqlite3_finalize(statement)

        return tickets.isEmpty ? .failure(.noRecordFound("No tickets found for the given date.")) : .success(tickets)
   
    }

    func removeTicket(agentId: Int, ticketId: Int) -> Result<Void, DatabaseError> {
        let query = Queries.removeTicket
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        
        sqlite3_bind_int(statement, 1, Int32(ticketId))
        sqlite3_bind_int(statement, 2, Int32(agentId))

        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_finalize(statement)
            return .success(())
        } else {
            sqlite3_finalize(statement)
            return .failure(.executionFailed("Failed to insert user. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
    }
    
    func getAllTickets() -> Result<[Ticket], DatabaseError> {
        let query = Queries.getAllTickets
        var statement: OpaquePointer?
        var tickets: [Ticket] = []

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        
        defer {
            sqlite3_finalize(statement)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        while sqlite3_step(statement) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(statement, 0))
            let title = String(cString: sqlite3_column_text(statement, 1))
            let description = String(cString: sqlite3_column_text(statement, 2))
            let userId = Int(sqlite3_column_int(statement, 3))
            let agentId = Int(sqlite3_column_int(statement, 4))
            let priorityValue = Int(sqlite3_column_int(statement, 5))
            let statusRawValue = sqlite3_column_text(statement, 7) != nil ? String(cString: sqlite3_column_text(statement, 6)) : nil
            let createdDateString = sqlite3_column_text(statement, 6) != nil ? String(cString: sqlite3_column_text(statement, 7)) : nil
            
            let issueTypeRawValue = sqlite3_column_text(statement, 8) != nil ? String(cString: sqlite3_column_text(statement, 8)) : nil

            let createdDate: Date
            if let dateString = createdDateString, let date = dateFormatter.date(from: dateString) {
                createdDate = date
            } else {
                createdDate = Date()
                print("Warning: Invalid or missing date string for ticket ID \(id). Defaulting to current date.")
            }

            let status = statusRawValue.flatMap { _ in TicketStatus(rawValue: statusRawValue ?? "created") } ?? .created

            let issueType = issueTypeRawValue.flatMap { IssueType(rawValue: $0) } ?? .software

            guard let priority = Priority(rawValue: priorityValue) else {
                print("Invalid priority value: \(priorityValue) for ticket ID \(id). Skipping.")
                continue
            }

            let ticket = Ticket(id: id, title: title, description: description, createdDate: createdDate, status: status, userId: userId, agentId: agentId, issueType: issueType, priority: priority)

            tickets.append(ticket)
        }

        return tickets.isEmpty
            ? .failure(.noRecordFound("No tickets found."))
            : .success(tickets)
    }

    func updatePriority(ticketId: Int, newPriority: Int) -> Result<Void, DatabaseError> {
        let query = Queries.updateTicketPriority
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare UPDATE statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }

        sqlite3_bind_int(statement, 1, Int32(newPriority))
        sqlite3_bind_int(statement, 2, Int32(ticketId))

        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_finalize(statement)
            return .success(())
        } else {
            sqlite3_finalize(statement)
            return .failure(.executionFailed("Failed to update ticket priority. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
    }
    
    func getLastCreatedTicketId() -> Result<Int, DatabaseError> {
        let query = Queries.getLastTicketId
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        if sqlite3_step(statement) == SQLITE_ROW {
            let userId = Int(sqlite3_column_int(statement, 0))
            return .success(userId)
        }
        else {
            return .failure(.noRecordFound("No ticketId Found"))
        }
        
    }

}
