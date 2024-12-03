//
//  Queries.swift
//  HelpDeskManagement
//
//  Created by incubation on 26/11/24.
//

struct Queries {
    static let createUserTable = """
    CREATE TABLE IF NOT EXISTS Users (
        user_id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        role TEXT NOT NULL
    );
    """
    static let getAllUsers = "SELECT * FROM Users;"
    static let addUser = "INSERT INTO Users (name, role) VALUES (?, ?)"
    static let getUserById = "SELECT * FROM Users where user_id = ?"
    static let createTicketTable = """
    CREATE TABLE IF NOT EXISTS "Tickets" (
    "ticket_id"    INTEGER,
    "title"    TEXT NOT NULL,
    "description"    TEXT NOT NULL,
    "user_id"    INTEGER NOT NULL,
    "agent_id"    INTEGER,
    "priority"    TEXT,
    "status"    TEXT NOT NULL,
    "created_at"    DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("ticket_id" AUTOINCREMENT),
    FOREIGN KEY("agent_id") REFERENCES "Agents"("agent_id"),
    FOREIGN KEY("user_id") REFERENCES "Users"("user_id")
);
"""
    static let createAgentTable = """
    CREATE TABLE IF NOT EXISTS "Agents" (
        "agent_id"    INTEGER,
        "department"    VARCHAR(100) NOT NULL,
        "availabilityStatus"    TEXT NOT NULL CHECK("availabilityStatus" IN ('available', 'busy', 'offline', 'leave')),
        "ticketsResolvedCount"    INTEGER DEFAULT 0,
        "userId"    INTEGER NOT NULL,
        "name"    TEXT,
        PRIMARY KEY("agent_id" AUTOINCREMENT),
        FOREIGN KEY("userId") REFERENCES "Users"("user_id")
    );
    """
    static let createAdminTable = """
    CREATE TABLE IF NOT EXISTS "admin" (
        "id"    INTEGER,
        "hasDefaultPassword"    BOOLEAN NOT NULL,
        "userId"    INTEGER NOT NULL,
        "name"    TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("userId") REFERENCES "Users"("user_id")
    );
    """
    
    static let createKnowledgeBadeTable = """
    CREATE TABLE IF NOT EXISTS "KnowledgeBase" (
        "kb_id"    INTEGER,
        "title"    VARCHAR(100) NOT NULL,
        "issue"    TEXT NOT NULL,
        "solution"    TEXT NOT NULL,
        "created_at"    DATETIME DEFAULT CURRENT_TIMESTAMP,
        "updated_at"    DATETIME DEFAULT CURRENT_TIMESTAMP,
        "userId"    INTEGER NOT NULL,
        PRIMARY KEY("kb_id" AUTOINCREMENT),
        FOREIGN KEY("userId") REFERENCES "Users"("user_id")
    );
    """
    static let createLogsEntryTable = """
    CREATE TABLE IF NOT EXISTS "LogsEntry" (
        "log_id"    INTEGER,
        "user_id"    INTEGER NOT NULL,
        "message"    TEXT NOT NULL,
        "timestamp"    DATETIME DEFAULT CURRENT_TIMESTAMP,
        "logType"    TEXT NOT NULL,
        PRIMARY KEY("log_id" AUTOINCREMENT),
        FOREIGN KEY("user_id") REFERENCES "Users"("user_id")
    );
    """
    static let createUserNameAndPasswordTable = """
    CREATE TABLE IF NOT EXISTS "userNameAndPasswords" (
        "id"    INTEGER,
        "userName"    TEXT NOT NULL UNIQUE,
        "password"    TEXT NOT NULL,
        "userId"    INTEGER NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("userId") REFERENCES "Users"("user_id")
    );
    """
    static let createAssignedTicketsTable = """
    CREATE TABLE IF NOT EXISTS "AssignedTickets" (
        "id"    INTEGER,
        "ticketId"    INTEGER NOT NULL,
        "agentId"    INTEGER NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("agentId") REFERENCES "Agents"("agent_id"),
        FOREIGN KEY("ticketId") REFERENCES "Tickets"("ticket_id")
    );
    """
    static let addTicket = "INSERT INTO Tickets (title, description, user_id,priority,status,issueType) values (?,?,?,?,?,?)"
    static let getUserCreatedTickets = "SELECT * FROM Tickets  WHERE user_id = ?"
    static let updateTicketStatus = "UPDATE Tickets SET status = ? WHERE ticket_id = ?"
    static let getAgentTickets = """
        SELECT T.ticket_id, T.title, T.description, T.user_id, T.agent_id, 
               T.priority, T.created_at, T.status, T.issueType
        FROM Tickets AS T
        INNER JOIN AssignedTickets AS AT ON T.ticket_id = AT.ticketId
        WHERE AT.agentId = ?
        """

    static let findAgentByTicketId = "SELECT Agents.agent_id, Agents.department, Agents.availabilityStatus, Agents.ticketsResolvedCount, Agents.userId,Agents.name FROM Agents INNER JOIN Tickets ON Agents.userId = Tickets.agent_id WHERE Tickets.ticket_id = ?;"
    static let getTicketById = "SELECT * FROM Tickets WHERE ticket_id = ?"
    static let getTicketByDate = "SELECT * FROM Tickets WHERE DATE(created_at) = ?;"
    static let addKnowledgeBaseEntry = "INSERT INTO KnowledgeBase (title, issue,solution,userId) VALUES (?, ?, ?, ?); "
    static let getAllKnowledgeBaseEntries = "SELECT * FROM KnowledgeBase;"
    static let updateKnowledgeBaseEntry = "UPDATE KnowledgeBase SET solution = ? , updated_at = ? where kb_id = ?"
    static let getKnowledgeBaseEntryById = "SELECT * FROM KnowledgeBase where kb_id = ?"
    static let addAgent = "INSERT INTO Agents (department, availabilityStatus,userId, name) values ( ?, ?, ?, ?)"
    static let updateAgentAvailability = "UPDATE Agents SET availabilityStatus = ? where agent_id = ?"
    static let getAgentById = "SELECT * from Agents WHERE agent_id = ?"
    static let getAllAgents = "SELECT * from Agents"
    static let addTicketToAgent = "INSERT INTO AssignedTickets (ticketId, agentId) VALUES(?,?);"
    static let updatePassword = "UPDATE userNameAndPasswords SET password = ? where userId = ?;"
    static let removeTicket = "DELETE FROM AssignedTickets WHERE ticketId = ? AND agentId = ?;"
    static let addUserNameAndPassword = "INSERT INTO userNameAndPasswords (userName, password, userId) values (?,?,?);"
    static let getUserNameAndPassword = "SELECT userName, password FROM userNameAndPasswords where userId = ?; "
    static let getuserRole = """
    SELECT Users.role , Users.user_id
    FROM Users 
    JOIN userNameAndPasswords
    ON Users.user_id = userNameAndPasswords.userId 
    WHERE userNameAndPasswords.userName = ?
    AND userNameAndPasswords.password = ?;
   """
    static let getAgentByUserId = "SELECT * FROM Agents WHERE userId = ?;"
    static let getAdminByUserId = "SELECT * FROM admin WHERE userId = ?;"
    static let getUserByUserId = "SELECT * FROM Users WHERE userId = ?;"
    static let getAllTickets = "SELECT * FROM Tickets;"
    static let getLastUserId = "SELECT MAX(user_id) AS lastUserId FROM Users;"
    static let getLastTicketId = "SELECT MAX(ticket_id) AS lastTicketId FROM Tickets;"
    static let addLogEntry = "INSERT INTO LogsEntry (user_id,message,logType) VALUES (?,?,?)"
    static let getAllLogsEntry = "SELECT * FROM LogsEntry"
    static let assignAgentToTicket = "UPDATE Tickets SET agent_id = ? WHERE ticket_id = ?;"
    static let updateTicketPriority = "UPDATE  Tickets SET priority = ? WHERE ticket_id = ?"
    static let updateTicketResolvedCount = "UPDATE Agents SET ticketsResolvedCount = ? WHERE agent_id = ?"
    static let updateDefaultPassword = "UPDATE admin SET hasDefaultPassword = ? WHERE userId = ?"

}
