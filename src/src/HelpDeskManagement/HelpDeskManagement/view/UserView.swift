//
//  UserView.swift
//  HelpDeskManagement
//
//  Created by incubation on 07/11/24.
//

import Foundation

struct UserView {
    private var ticketController : TicketController?
    private var userController : UserController?
    private var knowledgeBase : KnowledgeBaseController?
    //private var mainView = MainView()
   
    mutating func setTicketController(ticketController : TicketControllerImpl) {
        self.ticketController = ticketController
    }
    mutating func setUserController(userController : UserControllerImpl) {
        self.userController = userController
    }
    mutating func setKnowledgeBaseController(knowledgeBaseController : KnowledgeBaseController) {
        self.knowledgeBase = knowledgeBaseController
    }
    
    func userMenu() {
        print("==== User Dashboard ====")

        print("Welcome, [User Name]")
        print("1. Create a New Ticket")
        print("2. View My Tickets")
        print("3. Check Notifications")
        print("4. Search Knowledge Base")
        print("5. Logout")

        print("Select an option: ")
        let option = Int(readLine()!)
        
        switch option {
        case 1 :
            createTicket()
        case 2 :
            viewMyTicket()
        case 3 :
            checkNotifications()
        case 4:
            searchKnowledgeBase()
        case 5:
            mainView.showLoginScreen()
            
        default :
            print("Invalid Option")
        }
    }
    
    func createTicket() {
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
        
        print("Enter the userId ")
        guard let userId = Int(readLine()!) else {
            print("Invalid userId")
            return
        }
        ticketController?.createTicket(title: ticketTitle, description: ticketDescription, priority: nil, createdDate: Date(), status: TicketStatus.created, agentId: nil, userId: userId)
        userMenu()
    }
    
    func viewMyTicket() {
        print("Enter the userId: ")
        
        guard let userIdString = readLine(), let userId = Int(userIdString) else {
            print("Invalid input. Please enter a valid user ID.")
            userMenu()
            return
        }
        
        guard let userController = userController else {
            print("User controller not available.")
            userMenu()
            return
        }
        
        guard let user = userController.getUserById(userId: userId) else {
            print("User with ID \(userId) not found.")
            userMenu()
            return
        }
        
        let tickets = userController.getAllTheCreatedTickets(user: user)
        if tickets.isEmpty {
            print("No tickets found for user with ID \(userId).")
            userMenu()
            return
        }
        
        for ticket in tickets {
            print("Ticket Id : \(ticket.getTicketId)")
            print("Ticket Title : \(ticket.getTicketTitle)")
            print("Ticket Status : \(ticket.statusProperty)")
        }
        
        userMenu()
    }


    
    func checkNotifications() {
        print("Enter the UserId: ")
        
        guard let userIdString = readLine(), let userId = Int(userIdString) else {
            print("Invalid input. Please enter a valid user ID.")
            return
        }
        
        guard let notifications = userController?.getUserNotifications(userId: userId), !notifications.isEmpty else {
            print("No notifications found for user with ID \(userId).")
            return
        }
        
        for (_, notification) in notifications {
            print("Message: \(notification)")
        }
        userMenu()
    }

    
    func searchKnowledgeBase() {
        print("Enter the Ticket Title:")
        guard let ticketTitle = readLine(), !ticketTitle.isEmpty else {
            print("Invalid Title")
            return
        }
        print("Enter the Tag :")
        guard let tag  = readLine(), !tag.isEmpty else {
            print("Invalid Ticket tag")
            return
        }
        let knowledgeBaseEntry = knowledgeBase?.search(title: ticketTitle, tag: tag)
        print("Title : \(String(describing: knowledgeBaseEntry?.titleproperty))")
        print("Solution : \(String(describing: knowledgeBaseEntry?.solutionProperty)) ")
        
        userMenu()
    }
    
    func register() {
        print("Enter the name:")
        let name = readLine()!
        
        if !Validation.validateName(name) {
            print("Please Enter Valid Name")
            register()
        }
        
        print("Enter the user role (admin, vip, standard, guest):")
        if let roleString = readLine(), let role = UserRole(role: roleString) {
            print("Enter the User Name:")
            let userName = readLine()!
            
            if !Validation.validateUsername(userName) {
                print("Please Enter Valid UserName")
                register()
            }
            
            print("Enter the password:")
            let password = readLine()!
            
            if !Validation.validatePassword(password) {
                print("Please Enter Valid Password")
                register()
            }
            
            if let userController = userController {
                let userId = userController.register(name: name, userRole: role, userName: userName, password: password)
                print("User Id : \(userId)") 
            } else {
                print("Error: userController is not initialized")
            }
        } else {
            print("Invalid role entered. Please try again.")
        }
        userMenu()
    }


}
