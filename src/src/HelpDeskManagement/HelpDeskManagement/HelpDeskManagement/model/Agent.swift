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
    private var assignedTickets : [Ticket] = []
    private var department : String
    private var perfomance : AgentPerfomance?
    private let userName : String
    private var password : String
    private static var agentCount = 0
    
    init(name: String,department: String,userName: String, password: String, ticketResolved : Int, status : AgentStatus) {
        Agent.agentCount += 1
        self.id = Agent.agentCount
        self.name = name
        self.ticketResolved = 0
        self.status = AgentStatus.available
        self.department = department
        self.userName = StringHasher.hash(userName)
        self.password = StringHasher.hash(password)
    }
    
    convenience init(name : String, deparment : String, userName : String, password : String) {
        self.init(name: name, department: deparment, userName: userName, password: password, ticketResolved: 0, status: AgentStatus.available)
    }
    
    var getId : Int {
        return id
    }
    
    var getName : String {
        return name
    }
    
    var getUserName : String {
        return userName
    }
    var passwordproperty : String {
        get {
            return password
        }
        set(newPassword) {
            password = newPassword
        }
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
            _ = status
            status = newStatus
        }
    }
    
    var assignedTicketsProperty : [Ticket] {
        get {
            return assignedTickets
        }
        set(newTicket) {
            assignedTickets = newTicket
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
    
    deinit{
        
    }
    
}

extension Agent: Loggable {
    var logType: LogType {
        return .info
    }
    
    var logMessage: String {
        return ""
    }
    
    var logId : Int {
        return self.getId
    }
}
extension Agent: Hashable {
    static func == (lhs: Agent, rhs: Agent) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
