//
//  Agent.swift
//  HelpDeskManagement
//
//  Created by incubation on 05/11/24.
//

class Agent {
    private let id : Int
    private let name : String
    private var ticketResolved : Int
    private var status : AgentStatus
    private var assignedTickets : [Ticket]? = []
    private var department : String
    private var perfomance : AgentPerfomance?
    private let userName : String
    private var password : String
    private static var agentCount = 0
    
    init(name: String,department: String,userName: String, password: String) {
        Agent.agentCount += 1
        self.id = Agent.agentCount
        self.name = name
        self.ticketResolved = 0
        self.status = AgentStatus.available
        self.department = department
        self.userName = userName
        self.password = password
    }
    
    var getId : Int {
        return id
    }
    
    var getName : String {
        return name
    }
    
    var ticketResolvedProperty : Int {
        get{
            return ticketResolved
        }
        
        set(ticketResolvedCount) {
            self.ticketResolved += ticketResolvedCount
        }
    }
    
    var statusProperty : AgentStatus {
        get {
            return status
        }
        set(newStatus) {
            self.status = newStatus
        }
    }
    
    var assignedTicketsProperty : [Ticket] {
        get {
            return assignedTickets ?? []
        }
        set(newTicket) {
            assignedTickets = newTicket
        }
    }
    
    func addTicket(ticket: Ticket) {
        assignedTickets = (assignedTickets ?? []) + [ticket]
    }
    
    var departmentProperty : String {
        get {
            return department
        }
        
        set(newDepartment) {
            department = newDepartment
        }
    }
    
    var perfomanceProperty : AgentPerfomance? {
        get {
            if perfomance != nil {
                return perfomance
            }
            return nil
        }
        set(newPerfomance) {
            perfomance = newPerfomance
        }
    }
    
}
