//
//  UserView.swift
//  HelpDeskManagement
//
//  Created by incubation on 07/11/24.
//

import Foundation

struct UserView {
    private weak var ticketController : TicketController?
    private weak var userController : UserController?
    private weak var knowledgeBase : KnowledgeBaseController?
    private var loginedUser : User?
    
    mutating func setTicketController(ticketController : TicketControllerImpl) {
        self.ticketController = ticketController
    }
    mutating func setUserController(userController : UserControllerImpl) {
        self.userController = userController
    }
    mutating func setKnowledgeBaseController(knowledgeBaseController : KnowledgeBaseController) {
        self.knowledgeBase = knowledgeBaseController
    }
    mutating func setLoginedUser(user : User) {
        self.loginedUser = user
    }
    
    func userMenu() {
        
        print("==== User Dashboard ====")

        print("Welcome, [User Name]")
        print("1. Create a New Ticket")
        print("2. View My Tickets")
        print("3. Search Knowledge Base")
        print("4. Logout")

        print("Select an option: ")
        let option = Int(readLine()!)
        
        switch option {
        case 1 :
            createTicket(user : loginedUser!)
        case 2 :
            viewMyTicket(user : loginedUser!)
        case 3:
            searchKnowledgeBase()
        case 4:
            mainView.showLoginScreen()
            
        default :
            print("Invalid Option")
            userMenu()
        }
    }
    
    func createTicket(user : User) {
        print("Enter the Ticket Title:")
        guard let ticketTitle = readLine(), !ticketTitle.isEmpty && Validation.validateName(ticketTitle) else {
            print("Invalid Title")
            return
        }
        
        print("Enter the Description :")
        guard let ticketDescription  = readLine(), !ticketDescription.isEmpty else {
            print("Invalid Ticket Description")
            return
        }
        
        ticketController?.createTicket(title: ticketTitle, description: ticketDescription, priority: nil, createdDate: Date(), status: TicketStatus.created, agentId: nil, userId: user.getUserId)
        userMenu()
    }
    
    func viewMyTicket(user : User) {
        
        guard let userController = userController else {
            print("User controller not available.")
            userMenu()
            return
        }
        
        let tickets = userController.getAllTheCreatedTickets(user: user)
        if tickets.isEmpty {
            print("No tickets found for user with ID \(user.getUserId).")
            userMenu()
            return
        }
        print("-------------Tickets-----------------")
        for ticket in tickets {
            print("--------------------------------------------------")
            print("Ticket Id : \(ticket.getTicketId)")
            print("Ticket Title : \(ticket.getTicketTitle)")
            print("Ticket Status : \(ticket.statusProperty)")
        }
        print("--------------------------------------------------")
        
        userMenu()
    }
    
//    func checkNotifications() {
//        print("Enter the UserId: ")
//        
//        guard let userIdString = readLine(), let userId = Int(userIdString) else {
//            print("Invalid input. Please enter a valid user ID.")
//            userMenu()
//            return
//        }
//        
//        guard let notifications = userController?.getUserNotifications(userId: userId), !notifications.isEmpty else {
//            print("No notifications found for user with ID \(userId).")
//            userMenu()
//            return
//        }
//        
//        for (_, notification) in notifications {
//            print("Message: \(notification)")
//        }
//        userMenu()
//    }
    
    func searchKnowledgeBase() {
        print("Enter the Ticket Title:")
        guard let ticketTitle = readLine(), !ticketTitle.isEmpty else {
            print("Invalid Title")
            return
        }
        print("Enter the Tag:")
        guard let tag = readLine(), !tag.isEmpty else {
            print("Invalid Ticket tag")
            return
        }

        if let knowledgeBaseEntry = knowledgeBase?.search(title: ticketTitle, tag: tag) {
            print("-----------------------------------------------------")
            print("Title: \(knowledgeBaseEntry.titleproperty)")
            print("Solution: \(knowledgeBaseEntry.solutionProperty)")
            print("-----------------------------------------------------")
        } else {
            print("No matching knowledge base entry found.")
        }

        userMenu()
    }
    
    func register() -> User? {
        print("Enter the name:")
        let name = readLine()!
        
        if !Validation.validateName(name) {
            print("Please Enter Valid Name")
            //register()
        }
        
        print("Enter the user role (vip, standard, guest):")
        if let roleString = readLine(), let role = UserRole(role: roleString) {
            print("Enter the User Name:")
            let userName = readLine()!
            
            if !Validation.validateUsername(userName) {
                print("Please Enter Valid UserName")
               // register()
            }
            
            print("Enter the password:")
            let password = readLine()!
            
            if !Validation.validatePassword(password) {
                print("Please Enter Valid Password")
                //register()
            }
            
            guard let user = userController?.register(name: name, userRole: role, userName: userName, password: password) else {
                print("")
                userMenu()
                return nil
            }
            print("User Id : \(String(describing: user.getUserId))")
            return user
        } else {
            print("Invalid role entered. Please try again.")
        }
        userMenu()
        return nil
    }
}
