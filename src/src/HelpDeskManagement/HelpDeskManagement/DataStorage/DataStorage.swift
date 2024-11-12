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
    
//    static var getAllTickets : [Int : Ticket] {
//        return allTickets
//    }
//    static var getAllAgents : [Int : Agent] {
//        return allAgents
//    }
//    static var getAllUsers : [Int : User] {
//        return allUsers
//    }
//    static var getAllLogsEntry : [Int : LogsEntry] {
//        return allLogsEntry
//    }
//    static var getAllKnowledgeBaseEntry : [Int : KnowledgeBase] {
//        return knowledgeBaseEntry
//    }
}
