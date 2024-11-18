//
//  DataStorage.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//

struct DataStorage {    
    static var allTickets : [Int : Ticket] = [:]
    static var allAgents : [Int : Agent] = [:]
    static var allUsers : [Int : User] = [:]
    static var allLogsEntry : [Int : LogsEntry] = [:]
    static var knowledgeBaseEntry : [Int : KnowledgeBase] = [:]
    static var agentTickets : [Agent : [Ticket]] = [:]
}
