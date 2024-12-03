import Foundation

struct Main {
    private var userController : UserController
    private var agentController = AgentControllerImpl()
    init() {
        self.userController = UserControllerImpl()
    }

}

let main = Main()

var mainView = MainView( userController: UserControllerImpl())

mainView.showLoginScreen()
