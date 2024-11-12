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
    
    init(userController : UserControllerImpl) {
        self.userController = userController
        self.ticketController = TicketControllerImpl()
        self.agentController = AgentControllerImpl()
        self.knowledgeBaseController = KnowledgeBaseControllerImpl()
        self.reportAndAnalyticsController = ReportAndAnalyticsControllerImpl()
        
        setTicketController()
        setAgentController()
        setUserController()
        setKnowledgeBaseController()
        setUserViewControllers()
        setAdminViewControllers()
        setAgentViewControllers()
    }
    init() {
        
    }
    
    func setTicketController() {
        userController?.setTicketController(ticketController: ticketController!)
        reportAndAnalyticsController?.setTicketController(ticketController: ticketController!)
        agentController?.setTicketController(ticketController: ticketController!)
    }
    
    func setAgentController() {
        ticketController?.setAgentController(agentController: agentController!)
        reportAndAnalyticsController?.setAgentController(agentController: agentController!)
    }
    
    func setUserController() {
        ticketController?.setUserController(userController: userController!)
        agentController?.setUserController(userController : userController!)
    }
    
    func setKnowledgeBaseController() {
        agentController?.setKnowledgeBaseController(knowledgeBaseController: knowledgeBaseController!)
    }
    
    func setUserViewControllers() {
         userView.setTicketController(ticketController: ticketController as! TicketControllerImpl)
        userView.setUserController(userController : userController as! UserControllerImpl)
        userView.setKnowledgeBaseController(knowledgeBaseController: knowledgeBaseController!)
    }
    
    func setAdminViewControllers() {
        adminView.setTicketController(ticketController: ticketController as! TicketControllerImpl)
        adminView.setReportAndAnalyticsController(reportAndAnalyticsController: reportAndAnalyticsController as! ReportAndAnalyticsControllerImpl)
        adminView.setAgentController(agentController: agentController as! AgentControllerImpl)
    }
    
    func setAgentViewControllers() {
        agentView.setTicketController(ticketController: ticketController as! TicketControllerImpl)
        agentView.setKnowledgeBaseController(knowledgeBaseController: knowledgeBaseController as! KnowledgeBaseControllerImpl)
    }
    
    func showLoginScreen() {
        print("==== Welcome to Help Desk System ====")
        print("1. Register")
        print("2. Login")
        print("Enter the choice")
        let userChoice = Int(readLine()!)
        
        switch userChoice {
        case 1 :
            userView.register()
            userView.userMenu()
        case 2 :
            login()
            
        default :
            print("Invalid Choice")
        }
    }
    
    func login() {
        print("Enter Username:")
        guard let username = readLine(), !username.isEmpty else {
            print("Invalid Username")
            return
        }

        print("Enter Password:")
        guard let password = readLine(), !password.isEmpty else {
            print("Invalid Password")
            return
        }

        print("Enter Role (admin, agent, user):")
        if let roleString = readLine(), let role = Role(role: roleString.trimmingCharacters(in: .whitespacesAndNewlines)) {
            
            print("Attempting login with role: \(role)")

            if (userController?.authenticate(username: username, password: password, role: role)) != nil {
                print("Login successful for \(role) \(username)")
                navigateToRoleView(role: role)
            } else {
                print("Authentication failed. Please try again.")
            }
        } else {
            print("Invalid role entered.")
        }
    }


    func navigateToRoleView(role: Role) {
        
        switch role {
        case .admin:
            adminView.adminMenu()
        case .agent:
            agentView.agentMenu()
        case .user:
            userView.userMenu()
        }
    }
}
