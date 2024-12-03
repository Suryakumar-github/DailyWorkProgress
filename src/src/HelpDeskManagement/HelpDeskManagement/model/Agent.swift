//
//  Agent.swift
//  HelpDeskManagement
//
//  Created by incubation on 05/11/24.
//

class Agent : User {
    private var id : Int
    private let userId : Int
    private var ticketResolved : Int
    private var status : AgentStatus
    private var department : String
    private static var agentCount = 0
    
    init(name : String, department: String, ticketResolved : Int, status : AgentStatus, userId : Int) {
        Agent.agentCount += 1
        self.id = Agent.agentCount
        self.ticketResolved = 0
        self.status = AgentStatus.available
        self.department = department
        self.userId = userId
        super.init(userId: userId, name: name, userRole: nil, role: Role.agent)
    }
    
    convenience init(name : String, deparment : String, userId : Int) {
        self.init(name: name, department: deparment, ticketResolved: 0, status: AgentStatus.available, userId: userId)
        
    }
    
    convenience init(id : Int, name : String, department : String, status : AgentStatus, ticketResolved : Int, userId : Int) {
        self.init(name: name, department: department, ticketResolved: ticketResolved, status: status, userId: userId)
        self.id = id
        self.status = status
    }
    
    var getAgentId : Int {
        return id
    }
    
    var getUserId : Int {
        return userId
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
            status = newStatus
        }
    }
    
    var departmentProperty : String {
        get {
            return department
        }
        
        set(newDepartment) {
            department = newDepartment
        }
    }
    
    deinit{
        
    }
}

