import Foundation

struct Main {
    private var userController : UserController
    
    init() {
        self.userController = UserControllerImpl()
    }
    
    func loadAgents() {
        let agent1 = Agent(name: "agent1", deparment: "Software", userName: "Agent1", password: "Agent1@12")
        let agent2 = Agent(name: "agent2", deparment: "Hardware", userName: "Agent2", password: "Agent2@12")
        let agent3 = Agent(name: "agent3", deparment: "Security", userName: "Agent3", password: "Agent3@12")
        let agent4 = Agent(name: "agent4", deparment: "Network", userName: "Agent4", password: "Agent4@12")
        
        var agents = DataStorage.allAgents
        agents[agent1.getId] = agent1
        agents[agent2.getId] = agent2
        agents[agent3.getId] = agent3
        agents[agent4.getId] = agent4
        
        DataStorage.allAgents = agents
        let logsEntry1 = LogsEntry(timestamp: Date(), logType: LogType.info, message: "New Agent Logined with id : \(agent1.getId)", userId: agent1.getId)
        DataStorage.allLogsEntry[logsEntry1.getId] = logsEntry1
        let logsEntry2 = LogsEntry(timestamp: Date(), logType: LogType.info, message: "New Agent Logined with id : \(agent2.getId)", userId: agent2.getId)
        DataStorage.allLogsEntry[logsEntry2.getId] = logsEntry2
        let logsEntry3 = LogsEntry(timestamp: Date(), logType: LogType.info, message: "New Agent Logined with id : \(agent3.getId)", userId: agent3.getId)
        DataStorage.allLogsEntry[logsEntry3.getId] = logsEntry3
        let logsEntry4 = LogsEntry(timestamp: Date(), logType: LogType.info, message: "New Agent Logined with id : \(agent4.getId)", userId: agent4.getId)
        DataStorage.allLogsEntry[logsEntry4.getId] = logsEntry4
    }
    
    func loadKnowledgeBaseEntries() {
        let entry1 = KnowledgeBase(
            title: "Software Installation Issue",
            issue: IssueType.software,
            solution: "Ensure you have the latest version of the installer...",
            tags: ["installation", "software", "admin rights"],
            createdDate: Date()
        )
        
        let entry2 = KnowledgeBase(
            title: "Printer Not Responding",
            issue: IssueType.hardware,
            solution: "Check if the printer is turned on...",
            tags: ["printer", "hardware", "connection"],
            createdDate: Date()
        )
        
        let entry3 = KnowledgeBase(
            title: "Slow Network Connection",
            issue: IssueType.network,
            solution: "Check the router and modem connection...",
            tags: ["network", "connection", "speed"],
            createdDate: Date()
        )
        
        let entry4 = KnowledgeBase(
            title: "Unauthorized Access Alert",
            issue: IssueType.security,
            solution: "Immediately change your password...",
            tags: ["security", "unauthorized access", "password"],
            createdDate: Date()
        )
        
        var knowledgeBaseEntries = DataStorage.knowledgeBaseEntry
        
        knowledgeBaseEntries[entry1.getId] = entry1
        knowledgeBaseEntries[entry2.getId] = entry2
        knowledgeBaseEntries[entry3.getId] = entry3
        knowledgeBaseEntries[entry4.getId] = entry4
        
        DataStorage.knowledgeBaseEntry = knowledgeBaseEntries
        let logsEntry1 = LogsEntry(timestamp: Date(), logType: LogType.info, message: "New Entrt added In Knowledge Base With Id : \(entry1.getId)", userId: entry1.getId)
        DataStorage.allLogsEntry[logsEntry1.getId] = logsEntry1
        let logsEntry2 = LogsEntry(timestamp: Date(), logType: LogType.info, message: "New Entrt added In Knowledge Base With Id  : \(entry2.getId)", userId: entry2.getId)
        DataStorage.allLogsEntry[logsEntry2.getId] = logsEntry2
        let logsEntry3 = LogsEntry(timestamp: Date(), logType: LogType.info, message: "New Entrt added In Knowledge Base With Id  : \(entry3.getId)", userId: entry3.getId)
        DataStorage.allLogsEntry[logsEntry3.getId] = logsEntry3
        let logsEntry4 = LogsEntry(timestamp: Date(), logType: LogType.info, message: "New Entrt added In Knowledge Base With Id  : \(entry4.getId)", userId: entry4.getId)
        DataStorage.allLogsEntry[logsEntry4.getId] = logsEntry4
        
    }

}
let main = Main()
main.loadAgents()
main.loadKnowledgeBaseEntries()

var mainView = MainView( userController: UserControllerImpl())
mainView.showLoginScreen()
