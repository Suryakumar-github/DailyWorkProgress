//
//  Ticket.swift
//  HelpDeskManagement
//
//  Created by incubation on 04/11/24.
//
import Foundation

class Ticket {
    
    private var id: Int
    private let title: String
    private var description: String
    private var priority: Priority?
    private let createdDate: Date
    private var status: TicketStatus
    private var agentId: Int?
    internal let userId : Int
    private static var ticketCount = 0
    private let issueType : IssueType
    
    init(title: String, description: String, priority: Priority? = nil, createdDate: Date, status: TicketStatus, agentId: Int? = nil, userId : Int, issueType : IssueType) {
        Ticket.ticketCount += 1
        self.id = Ticket.ticketCount
        self.title = title
        self.description = description
        self.priority = priority
        self.createdDate = createdDate
        self.status = status
        self.agentId = agentId
        self.userId = userId
        self.issueType = issueType
    }
    
    convenience init(id : Int,title: String, description: String, createdDate: Date, status: TicketStatus, userId : Int, issueType : IssueType) {
        self.init(title: title, description: description, priority: nil, createdDate: createdDate, status: status, agentId: nil, userId: userId, issueType: issueType)
        self.id = id
    }
    init(id : Int, title: String, description: String, createdDate: Date, status: TicketStatus, userId: Int,agentId: Int, issueType: IssueType, priority: Priority) {
        self.id = id
        self.title = title
        self.description = description
        self.createdDate = createdDate
        self.status = status
        self.userId = userId
        self.agentId = agentId
        self.issueType = issueType
        self.priority = priority
    }
    
    var getTicketId : Int {
        return id
    }
    var getTicketTitle : String {
        return title
    }
    var getIssueType : IssueType {
        return issueType
    }
    var descriptionproperty : String {
        get {
            return description
        }
        set(newDescription) {
            description = newDescription
        }
    }
    var priorityProperty : Priority? {
        get {
            return priority
        }
        set(newPriority) {
            priority = newPriority
        }
    }
    var getTicketCreatedDate : Date {
        return createdDate
    }
    var statusProperty : TicketStatus {
        get {
            return status
        }
        set(newStatus) {
            _ = status
            status = newStatus
        }
    }
    var getAgentId: Int? {
        get {
            return agentId
        }
        set {
            agentId = newValue
        }
    }

    var getUserId : Int {
        return userId
    }
    deinit{
        
    }
}

extension Ticket : Loggable {
    var logType: LogType {
        return .info
    }
    
    var logMessage: String {
        return ""
    }
    
    var logId: Int {
        return self.getTicketId
    }
}
