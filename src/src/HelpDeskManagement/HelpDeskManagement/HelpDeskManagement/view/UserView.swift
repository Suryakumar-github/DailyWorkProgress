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
        print("5. Change Password")
        print("6. Logout")

        print("Select an option: ")
        let option = Int(readLine()!)
        
        switch option {
        case 1 :
            createTicket(user : loginedUser!)
        case 2 :
            viewMyTicket(user : loginedUser!)
        case 3 :
            searchKnowledgeBase()
        case 4 :
            cancelTicket(user : loginedUser!)
        case 5 :
            changePassword(user : loginedUser!)
        case 6:
            mainView.showLoginScreen()
            
        default :
            print("Invalid Option")
            userMenu()
        }
    }
    
    func changePassword(user : User) {
        print("-----------------------------------------------------")
        print("Enter Password:")
        guard let password = readLine(), !password.isEmpty && Validation.validatePassword(password) else {
            print("Invalid Password")
            changePassword(user: user)
            return
        }
        guard let controller = userController else {
            print("Controller in nil")
            return
        }
        if (controller.changePassword(user : user, password : password)) {
            print("Password Changed Successfully ")
            print("-----------------------------------------------------")
            userMenu()
        }
        else {
            print("Old password and New password should not be the same ")
            print("-----------------------------------------------------")
            changePassword(user: user)
        }
    }
    
    func createTicket(user : User) {
        print("-----------------------------------------------------")
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
        print("Enter the issue type (1 : for software, 2 : for network, 3 : for hardware , 4 : for security")
        let choice = Int(readLine()!)
        var issue : IssueType.RawValue = ""
        switch choice {
        case 1:
            issue = "software"
        case 2:
            issue = "network"
        case 3:
            issue = "hardware"
        case 4:
            issue = "security"
        default :
            print("Invalid isuue type. Please enter a valid issue type (software, network, hardware, security).")
            createTicket(user: user)
        }
    
        
        ticketController?.createTicket(title: ticketTitle, description: ticketDescription, priority: nil, createdDate: Date(), status: TicketStatus.created, agentId: nil, userId: user.getUserId, issueType: IssueType(rawValue: issue) ?? IssueType.software)
        print("-----------------------------------------------------")
        userMenu()
    }
    
    func cancelTicket(user: User) {
        print("-----------------------------------------------------")
        while true {
            print("Enter the ticket ID to Cancel (or type 'exit' to go back):")
            
            if let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) {
                if input.lowercased() == "exit" {
                    print("Exiting to User Menu...")
                    print("-----------------------------------------------------")
                    userMenu()
                    return
                }
                
                if let ticketId = Int(input) {
                    let isCancelled = ticketController?.cancelTicket(user: user, ticketId: ticketId) ?? false
                    
                    if isCancelled {
                        print("Ticket \(ticketId) successfully canceled.")
                        print("-----------------------------------------------------")
                        userMenu()
                        return
                    } else {
                        print("User doesn't have a ticket with ticketId: \(ticketId). Please try again.")
                    }
                } else {
                    print("Invalid input. Please enter a valid ticket ID or type 'exit' to go back.")
                }
            }
        }
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
        print("                   My Tickets                     ")
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
        print("------------------Available Title's---------------------")
        let entries = DataStorage.knowledgeBaseEntry
        print("--------------------------------------------------------")
        for (_,entry) in entries {
            print("Title : \(entry.titleproperty)")
            print("Tag : \(entry.tagsProperty)")
        }
        print("--------------------------------------------------------")
        
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
        var name: String?
        var role: UserRole?
        var userName: String?
        var password: String?
        var user: User?
        print("-----------------------------------------------------")
        while user == nil {
            if name == nil {
                print("Enter the name:")
                let inputName = readLine() ?? ""
                if Validation.validateName(inputName) {
                    name = inputName
                } else {
                    print("Please enter a valid name.")
                    continue
                }
            }
            
            if role == nil {
                print("Enter the user role (vip, standard, guest):")
                if let roleString = readLine(), let parsedRole = UserRole(role: roleString) {
                    role = parsedRole
                } else {
                    print("Invalid role entered. Please try again.")
                    continue
                }
            }
            
            if userName == nil {
                print("Enter the username:")
                let inputUsername = readLine() ?? ""
                if Validation.validateUsername(inputUsername) {
                    userName = inputUsername
                } else {
                    print("Please enter a valid username.")
                    continue
                }
            }
            
            if password == nil {
                print("Enter the password:")
                let inputPassword = readLine() ?? ""
                if Validation.validatePassword(inputPassword) {
                    password = inputPassword
                } else {
                    print("Please enter a valid password.")
                    continue
                }
            }
            
            if let validName = name, let validRole = role, let validUsername = userName, let validPassword = password {
                if let registeredUser = userController?.register(name: validName, userRole: validRole, userName: validUsername, password: validPassword) {
                    user = registeredUser
                    print("User ID: \(String(describing: user!.getUserId))")
                    print("-----------------------------------------------------")
                } else {
                    print("Registration failed, please try again.")
                    name = nil
                    role = nil
                    userName = nil
                    password = nil
                }
            }
        }
        print("-----------------------------------------------------")
        return user
    }
}
