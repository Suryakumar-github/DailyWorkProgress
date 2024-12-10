//
//  MainView.swift
//  HelpDeskManagement
//
//  Created by incubation on 07/11/24.
//

import Foundation

class MainView {
    
    private var userController : UserController?
    private var userView =   UserView()
    
    init(userController : UserControllerImpl) {
        self.userController = userController
        setUserViewControllers()
    }
    
    func setUserViewControllers() {
        userView.setUserController(userController : userController!)
    }
    
    func showLoginScreen()   {
        print("----------------------------------------------------------------")
        print("             ==== Welcome to Help Desk System ====              ")
        print("----------------------------------------------------------------")
        print("1. Register as User")
        print("2. Login")
        print("3. Exit")
        print("----------------------------------------------------------------")
        print("Enter the choice")
        let userInput = readLine()!
        let userChoice = Int(userInput)
        
        switch userChoice {
        case 1 :
            guard let user =   userView.register() else {
                  showLoginScreen()
                return
            }
            userView.setLoginedUser(user: user)
              userView.userMenu()
        case 2 :
              login()
            
        case 3 :
            DatabaseConnector.closeDataBase()
            exit(0)
            
        default :
            print("Invalid Choice")
              showLoginScreen()
        }
    }
    
    private func login()   {
        print("----------------------------------------------------------------")
        
        while true {
            print("Enter Username (or enter 0 to go back) :")
            guard let username = readLine(), !username.isEmpty else {
                print("Invalid Username. Please try again.")
                continue
            }
            if username == "0" {
                print("Going Back to Main Menu..")
                  showLoginScreen()
            }

            print("Enter Password (or enter 0 to go back) :")
            guard let password = readLine(), !password.isEmpty else {
                print("Invalid Password. Please try again.")
                continue
            }
            if password == "0" {
                print("Going Back to Main Menu..")
                  showLoginScreen()
            }
            do {
                if let actor = try   userController?.authenticate(username: username, password: password) {
                    print("Login Successful for \(username)")
                    print("----------------------------------------------------------------")
                      navigateToRoleView(actor: actor)
                    return
                }
            }
            catch let error {
                print("Error while searching User : \(error.localizedDescription)")
                print("----------------------------------------------------------------")
                print("Do you want to try again? (1 to retry, enter any number to exit)")
                
                guard let choice = Int(readLine()!),
                      choice == 1 else {
                    print("Exiting login process...")
                      showLoginScreen()
                    return
                }
            }
        }
    }
    
    private func navigateToRoleView(actor: AnyObject)   {
        if let admin = actor as? Admin {
            if admin.getRole == .admin {
                var adminView =   AdminView()
                let adminController =   AdminControllerImpl()
                adminView.setAdminController(adminController: adminController)
                adminView.setLoginedUser(user: admin)
                if admin.isDefaultPassword {
                    print("Please change your default password.")
                      adminView.changePassword(user: admin as Admin)
                    do {
                        try   adminView.setDefaultpassword(passwordState: false, adminId : admin.getUserId)
                    }
                    catch let error {
                        print(error.localizedDescription)
                        print("----------------------------------------------------------------")
                          adminView.changePassword(user: admin as Admin)
                    }
                }
                  adminView.adminMenu()
            }
        } else if let agent = actor as? Agent, agent.getRole == .agent {
            let agentController =   AgentControllerImpl()
            var agentView =   AgentView()
            agentView.setAgentController(agentController: agentController)
            agentView.setLoginedUser(agent: agent as Agent)
              agentView.agentMenu()
        } else if let user = actor as? User, user.getRole == .user {
            userView.setLoginedUser(user: user as User)
              userView.userMenu()
        } else {
            print("Invalid actor type")
        }
    }

}
