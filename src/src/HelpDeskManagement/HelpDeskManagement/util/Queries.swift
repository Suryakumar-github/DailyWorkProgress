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
    
}
