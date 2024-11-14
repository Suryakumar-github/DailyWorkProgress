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
        print("4. Cancel Ticket")
        print("5. Logout")

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
            cancelTicket(user : loginedUser!)
        case 5:
            mainView.showLoginScreen()
            
        default :
            print("Invalid Option")
            userMenu()
        }
    }
    
    func createTicket(user : User) {
        print("Enter the Ticket Title:")
        guard let ticketTitle = readLine(), !ticketTitle.isEmpty  else {
            print("Invalid Title")
            createTicket(user: user)
            return
        }
        
        print("Enter the Description :")
        guard let ticketDescription  = readLine(), !ticketDescription.isEmpty else {
            print("Invalid Ticket Description")
            createTicket(user: user)
            return
        }
        
        ticketController?.createTicket(title: ticketTitle, description: ticketDescription, priority: nil, createdDate: Date(), status: TicketStatus.created, agentId: nil, userId: user.getUserId)
        userMenu()
    }
    
    func cancelTicket(user : User) {
        print("Enter the ticket ID to Cancel :")
        guard let ticketId = Int(readLine()!) else {
            print("Invalid ticket ID.")
            cancelTicket(user: user)
            return
        }
        if ((ticketController?.cancelTicket(user: user, ticketId: ticketId)) != nil) != true {
            print("Ticket with ID \(ticketId) has been successfully cancelled and removed.")
        }
        else {
            print("User Doesn't have Ticket with ticketId : \(ticketId)  ")
        }
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
        print("--------------------------------------------------")
        print("--------------------My Tickets--------------------")
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
            searchKnowledgeBase()
            return
        }
        print("Enter the Tag:")
        guard let tag = readLine(), !tag.isEmpty else {
            print("Invalid Ticket tag")
            searchKnowledgeBase()
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
        var name: String
        var role: UserRole?
        var userName: String
        var password: String
        var user: User?
        
        while true {
            print("Enter the name:")
            name = readLine()!
            
            if !Validation.validateName(name) {
                print("Please enter a valid name.")
                continue
            }
            
            print("Enter the user role (vip, standard, guest):")
            if let roleString = readLine(), let parsedRole = UserRole(role: roleString) {
                role = parsedRole
            } else {
                print("Invalid role entered. Please try again.")
                continue
            }
            
            print("Enter the username:")
            userName = readLine()!
            
            if !Validation.validateUsername(userName) {
                print("Please enter a valid username.")
                continue
            }
            
            print("Enter the password:")
            password = readLine()!
            
            if !Validation.validatePassword(password) {
                print("Please enter a valid password.")
                continue
            }
            
            if let registeredUser = userController?.register(name: name, userRole: role!, userName: userName, password: password) {
                user = registeredUser
                print("User ID: \(String(describing: user!.getUserId))")
                break
            } else {
                print("Registration failed, please try again.")
                continue
            }
        }
        
        return user
    }

}
