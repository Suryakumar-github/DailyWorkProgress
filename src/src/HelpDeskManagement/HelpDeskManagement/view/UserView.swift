//
//  UserView.swift
//  HelpDeskManagement
//
//  Created by incubation on 07/11/24.
//

import Foundation

struct UserView {
    
    private var userController : UserController?
    private var loginedUser : User?
    
    mutating func setUserController(userController : UserController) {
        self.userController = userController
    }
    
    mutating func setLoginedUser(user : User) {
        self.loginedUser = user
    }
    
    func userMenu() {
        
        print("==== User Dashboard ====")

        print("Welcome, \(String(describing: loginedUser?.getName))")
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
    
    func changePassword(user: User) {
        print("-----------------------------------------------------")
        
        while true {
            print("Enter the Current Password:")
            guard let currentPassword = readLine(), !currentPassword.isEmpty else {
                print("Invalid Password. Current password cannot be empty.")
                continue
            }
            
            print("Enter the New Password:")
            guard let newPassword = readLine(),
                  !newPassword.isEmpty,
                  Validation.validatePassword(newPassword) else {
                print("Invalid Password. Ensure it meets the required criteria.")
                continue
            }
            
            guard let controller = userController else {
                print("Controller is nil")
                return
            }
            do {
                if try controller.changePassword(user: user, password: newPassword, currentPassword: currentPassword) {
                    print("Password Changed Successfully.")
                    print("-----------------------------------------------------")
                    userMenu()
                    return
                } else {
                    print("New password cannot be the same as the current password.")
                    print("-----------------------------------------------------")
                }
            }
            catch let error {
                print("Error while change Password : \(error)")
            }
        }
    }
    
    func createTicket(user: User) {
        print("-----------------------------------------------------")
        
        print("Enter the Ticket Title:")
        guard let ticketTitle = readLine(), !ticketTitle.isEmpty else {
            print("Invalid Title")
            createTicket(user: user)
            return
        }
    
        print("Enter the Description:")
        guard let ticketDescription = readLine(), !ticketDescription.isEmpty else {
            print("Invalid Ticket Description")
            createTicket(user: user)
            return
        }
        
        print("Enter the issue type (1: software, 2: network, 3: hardware, 4: security):")
        guard let input = readLine(), let choice = Int(input), choice >= 1, choice <= 4 else {
            print("Invalid issue type. Please enter a valid issue type (1-4).")
            createTicket(user: user)
            return
        }
        
        let issue: IssueType.RawValue
        switch choice {
        case 1: issue = "software"
        case 2: issue = "network"
        case 3: issue = "hardware"
        case 4: issue = "security"
        default:
            fatalError("Unexpected choice value.")
        }
        do {
            try userController?.createTicket(
                title: ticketTitle,
                description: ticketDescription,
                createdDate: Date(),
                status: TicketStatus.created,
                userId: user.getId,
                issueType: IssueType(rawValue: issue) ?? .software
            )
            
            print("Ticket successfully created!")
            print("-----------------------------------------------------")
        }
        catch let error {
            print("Error while Creating Ticket : \(error)")
        }
        userMenu()
    }

    
    func cancelTicket(user: User) {
        print("-----------------------------------------------------")
        print("                 Available Tickets                   ")
        do {
            guard let tickets = try userController?.getAllTheCreatedTickets(user: user), !tickets.isEmpty else {
                print("No tickets found for user with ID \(user.getId).")
                userMenu()
                return
            }
            for ticket in tickets {
                if ticket.statusProperty != TicketStatus.cancelled && ticket.statusProperty != TicketStatus.closed && ticket.statusProperty != TicketStatus.solved {
                    print("--------------------------------------------------")
                    print("Ticket Id : \(ticket.getTicketId)")
                }
            }
        }
        catch {
            print("Error while fetching the Tickets : \(error)")
            userMenu()
        }
     
        print("--------------------------------------------------")
        while true {
            print("Enter the ticket ID to Cancel (or type '0' to go back):")
            
            if let input = Int(readLine()!) {
                if input == 0{
                    print("Exiting to User Menu...")
                    print("-----------------------------------------------------")
                    userMenu()
                    return
                }
                
                guard let controller = userController else {
                    print("UserController is Nil. Cannot procede further")
                    return
                }
                do {
                    let isCancelled = try controller.cancelTicket(user: user, ticketId: input)
                    
                    if isCancelled {
                        print("Ticket \(input) successfully canceled.")
                        print("-----------------------------------------------------")
                        userMenu()
                        return
                    } else {
                        print("User doesn't have a ticket with ticketId: \(input). Please try again.")
                    }
                }
                catch {
                    print("Error : \(error)")
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
        do {
            let tickets = try userController.getAllTheCreatedTickets(user: user)
            if tickets.isEmpty {
                print("No tickets found for user with ID \(user.getId).")
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
        }
        catch let error {
            print("Error while fetching Tickets : \(error)")
        }
        
        userMenu()
    }

    func searchKnowledgeBase() {
        print("----------------------------------------------------------------")
        print("                  === KnowledgeBase Menu ===                    ")
        print("1. View All KnowledgeBase Entry")
        print("2. Search Using Specific Field")
        print("----------------------------------------------------------------")
        
        print("Please Choose an Option")
        let choice = Int(readLine()!)
        if choice == 1 {
            do {
                guard let entries = try userController?.getAllKnowledgeBaseEntries() else {
                    print("No Entries Found ")
                    userMenu()
                    return
                }
                print("------------------Available Title's---------------------")
                print("--------------------------------------------------------")
                for (entry) in entries {
                    print("Title : \(entry.titleproperty)")
                    print("Tag : \(entry.tagsProperty)")
                    print("Issue : \(entry.issueProperty)")
                    print("Solution : \(entry.solutionProperty)")
                }
                print("--------------------------------------------------------")
            }
            catch let error {
                print("Error while fetching the data : \(error)")
            }
            userMenu()
        }
        else if choice == 2 {
            print("Enter the word to Search")
            guard let word = readLine(), !word.isEmpty else {
                print("Invalid Word")
                searchKnowledgeBase()
                return
            }
            do {
                if let knowledgeBaseEntry = try userController?.search(word: word) {
                    print("-----------------Problem Solution-----------------------")
                    print("--------------------------------------------------------")
                    for entry in knowledgeBaseEntry {
                        print("Title: \(entry.titleproperty )")
                        print("Solution: \(entry.solutionProperty )")
                        print("---------------------------------------------------------")
                    }
                }
            }
            catch let error {
                print("Error while Fetching the data : \(error)")
            }
        }
        else {
            print("Invalid Option")
            searchKnowledgeBase()
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
                print("Choose the Subscription pack (1. 50$/month, 2. 30$/month, 3. 20$/month):")
                if let roleString = readLine() {
                    switch roleString {
                    case "1":
                        role = .vip
                        
                    case "2":
                        role = .standard
                        
                    case "3":
                        role = .guest
                        
                    default:
                        print("Invalid subscription choice. Please try again.")
                        continue
                    }
                } else {
                    print("Invalid input. Please try again.")
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

            if let validName = name, let validRole = role, let validUsername = userName, let validPassword = password{
                do {
                    if let registeredUser = try userController?.register(
                        name: validName,
                        userRole: validRole,
                        userName: validUsername,
                        password: validPassword
                    ) {
                        user = registeredUser
                        print("User ID: \(String(describing: user!.getId))")
                        print("-----------------------------------------------------")
                    } else {
                        print("Registration failed, please try again.")
                        name = nil
                        role = nil
                        userName = nil
                        password = nil
                        
                    }
                } catch let error {
                    print("Error while registering the User: \(error)")
                }
            }
        }
        print("-----------------------------------------------------")
        return user
    }

}
