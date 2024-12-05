//
//  MainView.swift
//  HelpDeskManagement
//
//  Created by incubation on 07/11/24.
//

import Foundation

class MainView {
    
    private var userController : UserController?
    private var dataBase : DataBase
    private lazy var userView = UserView()
    private var adminView = AdminView()
    private var agentView = AgentView()
    private var ticketController : TicketController?
    private var agentController : AgentController?
    private var knowledgeBaseController : KnowledgeBaseController?
    private var reportAndAnalyticsController : ReportAndAnalyticsController?
    private var adminController : AdminController?
    private var logsEntryController : LogsEntryController?
    
    init(userController : UserControllerImpl, dataBase : DataBase) {
        self.dataBase = dataBase
        self.userController = userController
        self.ticketController = TicketControllerImpl(dateBase: dataBase)
        self.agentController = AgentControllerImpl(dateBase: dataBase)
        self.knowledgeBaseController = KnowledgeBaseControllerImpl(dateBase: dataBase)
        self.reportAndAnalyticsController = ReportAndAnalyticsControllerImpl()
        self.adminController = AdminControllerImpl(dataBase: dataBase)
        self.logsEntryController = LogsEntryControllerImpl(dataBase: dataBase)
        
        
        setTicketController()
        setAgentController()
        setUserController()
        setKnowledgeBaseController()
        setUserViewControllers()
        setAdminViewControllers()
        setAgentViewControllers()
        setLogsEntryController()
    }
    func setLogsEntryController() {
        agentController?.setLogsEntryController(logsEntryController: logsEntryController!)
        ticketController?.setLogsEntryController(logsEntryController: logsEntryController!)
        userController?.setLogsEntryController(logsEntryController: logsEntryController!)
        knowledgeBaseController?.setLogsEntryController(logsEntryController: logsEntryController!)
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
        ticketController?.setKnowledgeBaseController(knowledgeBaseController: knowledgeBaseController!)
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
            guard let user = userView.register() else {
                showLoginScreen()
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
    
    private func login() {
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
    
    private func navigateToRoleView(actor: AnyObject) {
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
                        print(error.localizedDescription)
                        print("----------------------------------------------------------------")
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
