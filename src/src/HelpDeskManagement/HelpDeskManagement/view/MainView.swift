//
//  MainView.swift
//  HelpDeskManagement
//
//  Created by incubation on 07/11/24.
//

import Foundation

class MainView {
    
    private var userController : UserController?
    private lazy var userView = UserView()
    private var adminView = AdminView()
    private var agentView = AgentView()
    private var ticketController : TicketController?
    private var agentController : AgentController?
    private var knowledgeBaseController : KnowledgeBaseController?
    private var reportAndAnalyticsController : ReportAndAnalyticsController?
    private var adminController : AdminController?
    
    init(userController : UserControllerImpl) {
        self.userController = userController
        self.ticketController = TicketControllerImpl()
        self.agentController = AgentControllerImpl()
        self.knowledgeBaseController = KnowledgeBaseControllerImpl()
        self.reportAndAnalyticsController = ReportAndAnalyticsControllerImpl()
        self.adminController = AdminControllerImpl()
        
        setTicketController()
        setAgentController()
        setUserController()
        setKnowledgeBaseController()
        setUserViewControllers()
        setAdminViewControllers()
        setAgentViewControllers()
    }
    
    func setTicketController() {
        userController?.setTicketController(ticketController: ticketController!)
        reportAndAnalyticsController?.setTicketController(ticketController: ticketController!)
        agentController?.setTicketController(ticketController: ticketController!)
        adminController?.setTicketController(ticketController: ticketController!)
    }
    
    func setAgentController() {
        ticketController?.setAgentController(agentController: agentController!)
        reportAndAnalyticsController?.setAgentController(agentController: agentController!)
        ticketController?.setDelagate(ticketAssignmentDelegate: agentController as! TicketAssignmentDelegate)
        adminController?.setAgentController(agentController: agentController!)
        adminController?.setReportAndAnalyticsController(reportAndAnalyticsController: reportAndAnalyticsController!)
    }
    
    func setUserController() {
        ticketController?.setUserController(userController: userController!)
    }
    
    func setKnowledgeBaseController() {
        agentController?.setKnowledgeBaseController(knowledgeBaseController: knowledgeBaseController!)
        userController?.setKnowledgeBaseController(knowledgeBaseController: knowledgeBaseController as! KnowledgeBaseControllerImpl)
    }
    
    func setUserViewControllers() {
        userView.setUserController(userController : userController!)
    }
    
    func setAdminViewControllers() {
        adminView.setAdminController(adminController: adminController!)
    }
    
    func setAgentViewControllers() {
        agentView.setAgentController(agentController: agentController! as! AgentControllerImpl)
    }
    
    func showLoginScreen() {
        print()
        print("--------------------------------------------------------------")
        print("==== Welcome to Help Desk System ====")
        print("1. Register as User")
        print("2. Login")
        print("3. Exit")
        print("Enter the choice")
        let userChoice = Int(readLine()!)
        
        switch userChoice {
        case 1 :
            guard let user = userView.register() else {
                print("User is Not Registered")
                return
            }
            userView.setLoginedUser(user: user)
            userView.userMenu()
        case 2 :
            login()
            
        case 3 :
            exit(0)
            
        default :
            print("Invalid Choice")
            showLoginScreen()
        }
    }
    
    func login() {
        print("----------------------------------------------------------------")
        
        while true {
            print("Enter Username:")
            guard let username = readLine(), !username.isEmpty else {
                print("Invalid Username. Please try again.")
                continue
            }

            print("Enter Password:")
            guard let password = readLine(), !password.isEmpty else {
                print("Invalid Password. Please try again.")
                continue
            }
            do {
                if let actor = try userController?.authenticate(username: username, password: password) {
                    print("Login Successful for \(username)")
                    print("----------------------------------------------------------------")
                    navigateToRoleView(actor: actor)
                    return
                }
            }
            catch let error {
                print("Error while searching User : \(error)")
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
    
    func navigateToRoleView(actor: AnyObject) {
        if let admin = actor as? Admin {
            if admin.getRole == .admin {
                adminView.setLoginedUser(user: admin)
                if admin.isDefaultPassword {
                    print("Please change your default password.")
                    adminView.changePassword(user: admin as Admin)
                    do {
                        try adminView.setDefaultpassword(passwordState: false, adminId : admin.getUserId)
                    }
                    catch let error {
                        print(error)
                        adminView.changePassword(user: admin as Admin)
                    }
                }
                adminView.adminMenu()
            }
        } else if let agent = actor as? Agent, agent.getRole == .agent {
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
