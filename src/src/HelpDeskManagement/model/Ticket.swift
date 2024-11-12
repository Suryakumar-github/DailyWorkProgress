//
//  Ticket.swift
//  HelpDeskManagement
//
//  Created by incubation on 04/11/24.
//
import Foundation

class Ticket {
    
    private let id: Int
    private let title: String
    private var description: String
    private var priority: Priority?
    private let createdDate: Date
    private var status: TicketStatus
    private var agentId: Int?
    private let userId : Int
    private var ticketCount = 1
    
    init(title: String, description: String, priority: Priority? = nil, createdDate: Date, status: TicketStatus, agentId: Int? = nil, userId : Int) {
        ticketCount += 1
        self.id = ticketCount
        self.title = title
        self.description = description
        self.priority = priority
        self.createdDate = createdDate
        self.status = status
        self.agentId = agentId
        self.userId = userId
    }
    
    var getTicketId : Int {
        return id
    }
    var getTicketTitle : String {
        return title
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
}

