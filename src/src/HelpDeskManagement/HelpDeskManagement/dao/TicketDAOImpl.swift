import Foundation


class TicketDAOImpl : TicketDAO {
    
    init()  {
        
        do{
            try  DatabaseConnector.createTable(createTableQuery: Queries.createTicketTable)
        }
        catch {
            print("Error : \(error)")
        }
    }
    
    func addTicket(ticket: Ticket)  -> Result<Void, DatabaseError> {
        let baseQuery = "INSERT INTO Tickets (title, description, user_id, agent_id, priority, status, issueType) VALUES (?, ?, ?, ?, ?, ?, ?)"
        
        let data: [Any] = [
            ticket.getTicketTitle,
            ticket.descriptionproperty,
            ticket.getUserId,
            ticket.getAgentId ?? NSNull(),
            ticket.priorityProperty?.rawValue ?? 1,
            ticket.statusProperty.rawValue,
            ticket.getIssueType.rawValue
        ]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: baseQuery, data: data)

            return try  DatabaseConnector.insertRecord(query: finalQuery)
        } catch let error as DatabaseError {
            return .failure(error)
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func getTicketById(ticketId: Int)  -> Result<Ticket?, DatabaseError> {
        let query = "SELECT * FROM Tickets WHERE ticket_id = ?"
        let data: [Any] = [ticketId]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            let result = try  DatabaseConnector.executeQueryData(query: finalQuery)
            
            switch result {
            case .success(let ticketsData):
                guard let row = ticketsData.first,
                      let id = row["ticket_id"] as? Int,
                      let title = row["title"] as? String,
                      let description = row["description"] as? String,
                      let userId = row["user_id"] as? Int,
                      let priorityValue = row["priority"] as? Int,
                      let statusRawValue = row["status"] as? String,
                      let createdDateString = row["created_at"] as? String,
                      let issueTypeRawValue = row["issueType"] as? String
                else {
                    return .failure(.executionFailed("Failed to extract ticket data."))
                }
                let agentId = row["agent_id"] as? Int ?? 0
                
                let createdDate: Date
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let parsedDate = dateFormatter.date(from: createdDateString)
                    
                if parsedDate == dateFormatter.date(from: createdDateString) {
                    
                }  else {
                    
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let parsedDate = dateFormatter.date(from: createdDateString) {
                        createdDate = Calendar.current.startOfDay(for: parsedDate)
                    } else {
                        createdDate = Date()
                    }
                }
                
                guard let priority = Priority(rawValue: priorityValue) else {
                    return .failure(.executionFailed("Invalid priority value: \(priorityValue)"))
                }
                
                guard let status = TicketStatus(rawValue: statusRawValue) else {
                    return .failure(.executionFailed("Invalid status value: \(statusRawValue)"))
                }
                
                let issueType = IssueType(rawValue: issueTypeRawValue) ?? .software
                
                let ticket = Ticket(
                    id: id,
                    title: title,
                    description: description,
                    createdDate: parsedDate ?? Date(),
                    status: status,
                    userId: userId,
                    agentId: agentId,
                    issueType: issueType,
                    priority: priority
                )
                return .success(ticket)
                
            case .failure(let error):
                return .failure(error)
            }
            
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func getAllTheCreatedTickets(user: User)  -> Result<[Ticket], DatabaseError> {
        let query = "SELECT * FROM Tickets WHERE user_id = ?"
        let data: [Any] = [
            user.getId
        ]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            let result = try  DatabaseConnector.executeQueryData(query: finalQuery)
            
            switch result {
            case .success(let tickets):
                let ticketList = tickets.compactMap { row -> Ticket? in
                    guard let id = row["ticket_id"] as? Int,
                          let title = row["title"] as? String,
                          let description = row["description"] as? String,
                          let userId = row["user_id"] as? Int,
                          let priorityValue = row["priority"] as? Int,
                          let statusRawValue = row["status"] as? String,
                          let createdDateString = row["created_at"] as? String,
                          let issueTypeRawValue = row["issueType"] as? String
                    else {
                        return nil
                    }
                    
                    let agentId = row["agent_id"] as? Int ?? 0
                    
                    let createdDate: Date
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                    
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let parsedDate = dateFormatter.date(from: createdDateString)
                        
                    if parsedDate == dateFormatter.date(from: createdDateString) {
                        
                    }  else {
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        if let parsedDate = dateFormatter.date(from: createdDateString) {
                            createdDate = Calendar.current.startOfDay(for: parsedDate)
                        } else {
                            createdDate = Date()
                        }
                    }
                    
                    guard let priority = Priority(rawValue: priorityValue) else {
                        print("Invalid priority value: \(priorityValue)")
                        return nil
                    }
                    
                    guard let status = TicketStatus(rawValue: statusRawValue) else {
                        print("Invalid status value: \(statusRawValue)")
                        return nil
                    }
                    
                    let issueType = IssueType(rawValue: issueTypeRawValue) ?? .software
                    
                    return Ticket(id: id, title: title, description: description, createdDate: parsedDate ?? Date(), status: status, userId: userId, agentId: agentId, issueType: issueType, priority: priority)
                }
                
                return .success(ticketList)
                
            case .failure(let error):
                return .failure(error)
            }
            
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }

    func updateTicketStatus(ticketId: Int, status: TicketStatus)  -> Result<Void, DatabaseError> {
        let query = "UPDATE Tickets SET status = ? WHERE ticket_id = ?"
        let data : [Any] = [status.rawValue,ticketId]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            return try  DatabaseConnector.insertRecord(query: finalQuery)
        } catch let error as DatabaseError {
            return .failure(error)
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func findAgentByTicketId(ticketId: Int)  -> Result<Agent?, DatabaseError> {
        let query = "SELECT Agents.agent_id, Agents.department, Agents.availabilityStatus, Agents.ticketsResolvedCount, Agents.userId,Agents.name FROM Agents INNER JOIN Tickets ON Agents.userId = Tickets.agent_id WHERE Tickets.ticket_id = ?;"
        let data : [Any] = [ticketId]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            let result = try  DatabaseConnector.executeQueryData(query: finalQuery)
            switch result {
            case .success(let usersData):
                if let userDict = usersData.first,
                   let agentId = userDict["agent_id"],
                   let department = userDict["department"],
                   let availabiltyStatus = userDict["availabilityStatus"],
                   let ticketResolvedCount = userDict["ticketResolvedCount"],
                   let userId = userDict["userId"],
                   let name = userDict["name"] {
                    return .success(Agent(id: agentId as! Int, name: name as! String, department: department as! String, status: availabiltyStatus as! AgentStatus, ticketResolved: ticketResolvedCount as! Int, userId: userId as! Int))
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
    
    func fetchAssignedTickets(agent: Agent)  -> Result<[Ticket], DatabaseError> {
        let query = """
        SELECT T.ticket_id, T.title, T.description, T.user_id, T.agent_id, 
               T.priority, T.created_at, T.status, T.issueType
        FROM Tickets AS T
        INNER JOIN AssignedTickets AS AT ON T.ticket_id = AT.ticketId
        WHERE AT.agentId = ?
        """
        let data :[Any] = [agent.getAgentId]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            let result = try  DatabaseConnector.executeQueryData(query: finalQuery)
            
            switch result {
            case .success(let tickets):
                let ticketList = tickets.compactMap { row -> Ticket? in
                    guard let id = row["ticket_id"] as? Int,
                          let title = row["title"] as? String,
                          let description = row["description"] as? String,
                          let userId = row["user_id"] as? Int,
                          let priorityValue = row["priority"] as? Int,
                          let statusRawValue = row["status"] as? String,
                          let createdDateString = row["created_at"] as? String,
                          let issueTypeRawValue = row["issueType"] as? String
                    else {
                        return nil
                    }
                    
                    let agentId = row["agent_id"] as? Int ?? 0
                    
                    let createdDate: Date
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                    
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let parsedDate = dateFormatter.date(from: createdDateString)
                        
                    if parsedDate == dateFormatter.date(from: createdDateString) {
                        
                    }  else {
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        if let parsedDate = dateFormatter.date(from: createdDateString) {
                            createdDate = Calendar.current.startOfDay(for: parsedDate)
                        } else {
                            createdDate = Date()
                        }
                    }
                    
                    guard let priority = Priority(rawValue: priorityValue) else {
                        print("Invalid priority value: \(priorityValue)")
                        return nil
                    }
                    
                    guard let status = TicketStatus(rawValue: statusRawValue) else {
                        print("Invalid status value: \(statusRawValue)")
                        return nil
                    }
                    
                    let issueType = IssueType(rawValue: issueTypeRawValue) ?? .software
                    
                    return Ticket(id: id, title: title, description: description, createdDate: parsedDate ?? Date() , status: status, userId: userId, agentId: agentId, issueType: issueType, priority: priority)
                }
                
                return .success(ticketList)
                
            case .failure(let error):
                return .failure(error)
            }
            
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func getUnassignedTickets()  throws -> Result<[Ticket], DatabaseError> {
        let query = " SELECT * from Tickets WHERE status = 'created' "
        let result = try  DatabaseConnector.executeQueryData(query: query)
        
        switch result {
        case .success(let tickets):
            let ticketList = tickets.compactMap { row -> Ticket? in
                guard let id = row["ticket_id"] as? Int,
                      let title = row["title"] as? String,
                      let description = row["description"] as? String,
                      let userId = row["user_id"] as? Int,
                      let priorityValue = row["priority"] as? Int,
                      let statusRawValue = row["status"] as? String,
                      let createdDateString = row["created_at"] as? String,
                      let issueTypeRawValue = row["issueType"] as? String
                else {
                    return nil
                }
                let agentId = row["agent_id"] as? Int ?? 0
                
                let createdDate: Date
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let parsedDate = dateFormatter.date(from: createdDateString)
                    
                if parsedDate == dateFormatter.date(from: createdDateString) {
                    
                }  else {
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let parsedDate = dateFormatter.date(from: createdDateString) {
                        createdDate = Calendar.current.startOfDay(for: parsedDate)
                    } else {
                        createdDate = Date()
                    }
                }
                
                guard let priority = Priority(rawValue: priorityValue) else {
                    print("Invalid priority value: \(priorityValue)")
                    return nil
                }
                
                guard let status = TicketStatus(rawValue: statusRawValue) else {
                    print("Invalid status value: \(statusRawValue)")
                    return nil
                }
                
                let issueType = IssueType(rawValue: issueTypeRawValue) ?? .software
                
                return Ticket(id: id, title: title, description: description, createdDate: parsedDate ?? Date(), status: status, userId: userId, agentId: agentId, issueType: issueType, priority: priority)
            }
            
            return .success(ticketList)
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getTicketByDate(date: Date)  throws-> Result<[Ticket], DatabaseError> {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDateString = dateFormatter.string(from: date)

        let query = "SELECT * FROM Tickets WHERE DATE(created_at) = '\(formattedDateString)';"
        
        let result = try  DatabaseConnector.executeQueryData(query: query)
            
            switch result {
            case .success(let tickets):
                let ticketList = tickets.compactMap { row -> Ticket? in
                    guard let id = row["ticket_id"] as? Int,
                          let title = row["title"] as? String,
                          let description = row["description"] as? String,
                          let userId = row["user_id"] as? Int,
                          let priorityValue = row["priority"] as? Int,
                          let statusRawValue = row["status"] as? String,
                          let createdDateString = row["created_at"] as? String,
                          let issueTypeRawValue = row["issueType"] as? String
                    else {
                        return nil
                    }
                    let agentId = row["agent_id"] as? Int ?? 0
                    
                    let createdDate: Date
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                    
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let parsedDate = dateFormatter.date(from: createdDateString)
                        
                    if parsedDate == dateFormatter.date(from: createdDateString) {
                        
                    }  else {
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        if let parsedDate = dateFormatter.date(from: createdDateString) {
                            createdDate = Calendar.current.startOfDay(for: parsedDate)
                        } else {
                            createdDate = Date()
                        }
                    }
                    
                    guard let priority = Priority(rawValue: priorityValue) else {
                        print("Invalid priority value: \(priorityValue)")
                        return nil
                    }
                    
                    guard let status = TicketStatus(rawValue: statusRawValue) else {
                        print("Invalid status value: \(statusRawValue)")
                        return nil
                    }
                    
                    let issueType = IssueType(rawValue: issueTypeRawValue) ?? .software
                    
                    return Ticket(id: id, title: title, description: description, createdDate: parsedDate ?? Date(), status: status, userId: userId, agentId: agentId, issueType: issueType, priority: priority)
                }
                
                return .success(ticketList)
                
            case .failure(let error):
                return .failure(error)
            }
        
    }
    
    func getTicketsBetweendates(date1 : Date, date2 : Date) throws -> Result<[Ticket], DatabaseError> {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let formattedDateString1 = dateFormatter1.string(from: date1)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        let formattedDateString2 = dateFormatter2.string(from: date2)

        let query = "SELECT * FROM Tickets WHERE DATE(created_at) BETWEEN '\(formattedDateString1)' AND '\(formattedDateString2)';"
            
        let result = try  DatabaseConnector.executeQueryData(query: query)
            
            switch result {
            case .success(let tickets):
                let ticketList = tickets.compactMap { row -> Ticket? in
                    guard let id = row["ticket_id"] as? Int,
                          let title = row["title"] as? String,
                          let description = row["description"] as? String,
                          let userId = row["user_id"] as? Int,
                          let priorityValue = row["priority"] as? Int,
                          let statusRawValue = row["status"] as? String,
                          let createdDateString = row["created_at"] as? String,
                          let issueTypeRawValue = row["issueType"] as? String
                    else {
                        return nil
                    }
                    let agentId = row["agent_id"] as? Int ?? 0
                    
                    let createdDate: Date
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                    
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let parsedDate = dateFormatter.date(from: createdDateString)
                        
                    if parsedDate == dateFormatter.date(from: createdDateString) {
                        
                    }  else {
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        if let parsedDate = dateFormatter.date(from: createdDateString) {
                            createdDate = Calendar.current.startOfDay(for: parsedDate)
                        } else {
                            createdDate = Date()
                        }
                    }
                    
                    guard let priority = Priority(rawValue: priorityValue) else {
                        print("Invalid priority value: \(priorityValue)")
                        return nil
                    }
                    
                    guard let status = TicketStatus(rawValue: statusRawValue) else {
                        print("Invalid status value: \(statusRawValue)")
                        return nil
                    }
                    
                    let issueType = IssueType(rawValue: issueTypeRawValue) ?? .software
                    
                    return Ticket(id: id, title: title, description: description, createdDate: parsedDate ?? Date(), status: status, userId: userId, agentId: agentId, issueType: issueType, priority: priority)
                }
                
                return .success(ticketList)
                
            case .failure(let error):
                return .failure(error)
            }
    }

    func removeTicket(agentId: Int, ticketId: Int)  -> Result<Void, DatabaseError> {
        let query = "DELETE FROM AssignedTickets WHERE ticketId = ? AND agentId = ?;"
        let data: [Any] = [
            ticketId, agentId
        ]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            
            return try  DatabaseConnector.insertRecord(query: finalQuery)
        } catch let error as DatabaseError {
            return .failure(error)
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func getAllTickets()  throws -> Result<[Ticket], DatabaseError> {
        let query = "SELECT * FROM Tickets;"
        let result = try  DatabaseConnector.executeQueryData(query: query)
        
        switch result {
        case .success(let tickets):
            let ticketList = tickets.compactMap { row -> Ticket? in
                guard let id = row["ticket_id"] as? Int,
                      let title = row["title"] as? String,
                      let description = row["description"] as? String,
                      let userId = row["user_id"] as? Int,
                      let priorityValue = row["priority"] as? Int,
                      let statusRawValue = row["status"] as? String,
                      let createdDateString = row["created_at"] as? String,
                      let issueTypeRawValue = row["issueType"] as? String
                else {
                    return nil
                }
                let agentId = row["agent_id"] as? Int ?? 0
                
                let createdDate: Date
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let parsedDate = dateFormatter.date(from: createdDateString)
                    
                if parsedDate == dateFormatter.date(from: createdDateString) {
                    
                }  else {
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let parsedDate = dateFormatter.date(from: createdDateString) {
                        createdDate = Calendar.current.startOfDay(for: parsedDate)
                    } else {
                        createdDate = Date()
                    }
                }
                
                guard let priority = Priority(rawValue: priorityValue) else {
                    print("Invalid priority value: \(priorityValue)")
                    return nil
                }
                
                guard let status = TicketStatus(rawValue: statusRawValue) else {
                    print("Invalid status value: \(statusRawValue)")
                    return nil
                }
                
                let issueType = IssueType(rawValue: issueTypeRawValue) ?? .software
                
                return Ticket(id: id, title: title, description: description, createdDate: parsedDate ?? Date(), status: status, userId: userId, agentId: agentId, issueType: issueType, priority: priority)
            }
            
            return .success(ticketList)
            
        case .failure(let error):
            return .failure(error)
        }
    }

    func updatePriority(ticketId: Int, newPriority: Int)  -> Result<Void, DatabaseError> {
        let query = "UPDATE  Tickets SET priority = ? WHERE ticket_id = ?"
        let data: [Any] = [
            newPriority, ticketId
        ]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            
            return try  DatabaseConnector.insertRecord(query: finalQuery)
        } catch let error as DatabaseError {
            return .failure(error)
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func getLastCreatedTicketId()  throws -> Result<Int, DatabaseError> {
        let query = "SELECT MAX(ticket_id) AS lastTicketId FROM Tickets;"
        
        let result = try  DatabaseConnector.executeQueryData(query: query)
        
        switch result {
        case .success(let userIdData):
            if let userDict = userIdData.first,
               let lastUserId = userDict["lastTicketId"] as? Int {
                return .success(lastUserId)
            } else {
                return .failure(.executionFailed("Failed to extract the last created Ticket ID."))
            }
            
        case .failure(let error):
            return .failure(error)
        }        
    }
    
    func getTicketByStatus(agent : Agent, status : TicketStatus) throws -> Result<[Ticket], DatabaseError> {
        let query = "SELECT * FROM Tickets where status = '\(status.rawValue)';"
        let result = try  DatabaseConnector.executeQueryData(query: query)
        
        switch result {
        case .success(let tickets):
            let ticketList = tickets.compactMap { row -> Ticket? in
                guard let id = row["ticket_id"] as? Int,
                      let title = row["title"] as? String,
                      let description = row["description"] as? String,
                      let userId = row["user_id"] as? Int,
                      let priorityValue = row["priority"] as? Int,
                      let statusRawValue = row["status"] as? String,
                      let createdDateString = row["created_at"] as? String,
                      let issueTypeRawValue = row["issueType"] as? String
                else {
                    return nil
                }
                let agentId = row["agent_id"] as? Int ?? 0
                
                let createdDate: Date
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let parsedDate = dateFormatter.date(from: createdDateString)
                    
                if parsedDate == dateFormatter.date(from: createdDateString) {
                    
                }  else {
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let parsedDate = dateFormatter.date(from: createdDateString) {
                        createdDate = Calendar.current.startOfDay(for: parsedDate)
                    } else {
                        createdDate = Date()
                    }
                }
                
                guard let priority = Priority(rawValue: priorityValue) else {
                    print("Invalid priority value: \(priorityValue)")
                    return nil
                }
                
                guard let status = TicketStatus(rawValue: statusRawValue) else {
                    print("Invalid status value: \(statusRawValue)")
                    return nil
                }
                
                let issueType = IssueType(rawValue: issueTypeRawValue) ?? .software
                
                return Ticket(id: id, title: title, description: description, createdDate: parsedDate ?? Date(), status: status, userId: userId, agentId: agentId, issueType: issueType, priority: priority)
            }
            
            return .success(ticketList)
            
        case .failure(let error):
            return .failure(error)
        }
    }

}
