//
//  UserControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//

import Foundation

class UserControllerImpl : UserController {

    private weak var ticketController : TicketController?
    private var knowledgeBaseController : KnowledgeBaseController?
    private var logsEntryController : LogsEntryController?
    private var userDao : UserDAO
    
    init()   {
        self.userDao =   UserDAOImpl()
    }
    
    func setTicketController(ticketController: any TicketController) {
        self.ticketController = ticketController
    }
    
    func setKnowledgeBaseController(knowledgeBaseController : KnowledgeBaseControllerImpl) {
        self.knowledgeBaseController = knowledgeBaseController
    }
    
    func setLogsEntryController(logsEntryController: LogsEntryController) {
        self.logsEntryController = logsEntryController
    }
    
    func register(name : String, userRole : UserRole, userName : String, password : String)  throws -> User? {
        let id : Int
        let userId = try   userDao.getLastCreatedUserId()
        switch userId {
        case .success(let newId) :
            id = newId + 1
        case .failure(let error) :
            throw error
        }
        let user = User(userId: id, name: name, userRole: userRole, role : Role.user)
        let result =   userDao.addUser(user: user)
        switch result {
        case .success() :
            let result =   userDao.addUsersUserNamePassword(userName: userName, password: password, user: user)
            switch result {
            case .success() :
                try   logsEntryController?.log(logType: LogType.info, message: "New User Registered", userId: user.getId, data: user)
                return user
                
            case .failure(let error) :
                throw error
            }
            
        case .failure(let error) :
            throw error
        }
    }
    
    func createTicket (title : String, description : String, createdDate : Date, status : TicketStatus, userId : Int, issueType : IssueType)  throws {
        guard let controller = ticketController else {
            print("TicketController is Nil..")
            return
        }
        try   controller.createTicket(title: title, description: description, createdDate: createdDate, status: status, userId: userId, issueType: issueType)
    }
    
    func search(word: String)  throws -> [KnowledgeBase] {
        return try   knowledgeBaseController?.search(word: word) ?? []
    }
    
    func cancelTicket (user : User, ticketId : Int)  throws -> Bool {
        guard let controller = ticketController else {
            print("Ticket Controller is Nil..")
            return false
        }
        if   (try controller.cancelTicket(user: user, ticketId: ticketId)) {
            return true
        }
        return false
    }
    
    func changePassword(user: User, password newPassword: String, currentPassword: String)  throws -> Bool {

        let result =   userDao.getUserNameAndPassword(userId: user.getId)
        switch result {
        case .success(let credentials) :
             let storedPassword = credentials[1]

            if storedPassword != currentPassword {
                print("Current password is incorrect.")
                return false
            }

            if storedPassword == newPassword {
                return false
            }
            
            let result =   userDao.changePassword(user: user, newPassword: newPassword)
            switch result {
            case .success():
                return true
            case .failure(let error):
                throw error
            }
            
        case .failure(let error) :
            throw error
        }
    }

    func viewTicketStatus(ticketid: Int)   throws -> TicketStatus {
        let ticket = try   ticketController?.getTicketById(ticketId: ticketid)
        return ticket!.statusProperty
    }
    
    func getUserById(userId: Int)   throws -> User? {
        let result =   userDao.getUserById(userId: userId)
        switch result {
        case .success(let user) :
            return user
        case .failure(let error) :
            throw error
        }
    }

    func getAllTheCreatedTickets(user: User)   throws -> [Ticket] {
        return try   ticketController?.getAllTheCreatedTickets(user: user) ?? []
    }

    func authenticate(username: String, password: String)   throws -> AnyObject? {
        let result =   userDao.getUserRole(userName: username, password: password)
        switch result {
        case .success(let role):
            print("Role : \(role.0)")
            if role.0.lowercased() == Role.admin.rawValue.lowercased() {
                return try   getAdmin(userId: role.1)
            } else if role.0.lowercased() == Role.agent.rawValue.lowercased() {
                return try   getAgent(userId: role.1)
            } else if role.0.lowercased() == Role.user.rawValue.lowercased() {
                return try   getUser(userId: role.1)
            }

        case .failure(let error):
            throw error
        }
        return nil
    }

    func getAdmin(userId : Int)   throws -> Admin? {
        let result =   userDao.getAdminByUserId(userId: userId)
        switch result {
        case .success(let admin) :
            return admin
        case .failure(let error ) :
            throw error
        }
    }
    
    func getAgent(userId : Int)   throws -> Agent? {
        let result =   userDao.getAgentByUserId(userId: userId)
        switch result {
        case .success(let agent) :
            return agent
        case .failure(let error ) :
            throw error
        }
    }
    
    func getUser(userId : Int)   throws -> User? {
        let result =   userDao.getUserById(userId: userId)
        switch result {
        case .success(let user) :
            return user
        case .failure(let error ) :
            throw error
        }
    }
    
    func getAllKnowledgeBaseEntries()   throws -> [KnowledgeBase] {
        return try   knowledgeBaseController?.getAllKnowledgeBaseEntries() ?? []
    }
    
}
