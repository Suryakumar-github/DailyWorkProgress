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
    private var loginedUser = User(name: "sam", role: UserRole.vip, userName: "Sam12", password: "Sam@123")
    private var mainView = MainView()
   
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
        guard let ticketTitle = readLine(), !ticketTitle.isEmpty else {
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
        print("Enter the userId ")
        let userId = Int(readLine()!)!
        let user = (userController?.getUserById(userId: userId))!
        let tickets = userController?.getAllTheCreatedTickets(user: user)
        for ticket in tickets! {
            print("Ticket Id : \(ticket.getTicketId)")
            print("Ticket Title : \(ticket.getTicketTitle)")
            print("Ticket Status : \(ticket.statusProperty)")
        }
        userMenu()
    }
    
    func checkNotifications() {
        
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
    }
    
    func register() {
        print("Enter the name:")
        let name = readLine()!
        
        print("Enter the user role (admin, vip, standard, guest):")
        if let roleString = readLine(), let role = UserRole(role: roleString) {
            print("Enter the User Name:")
            let userName = readLine()!
            
            print("Enter the password:")
            let password = readLine()!
            
            userController?.register(name: name, userRole: role, userName: userName, password: password)
        } else {
            print("Invalid role entered. Please try again.")
        }
    }

}
