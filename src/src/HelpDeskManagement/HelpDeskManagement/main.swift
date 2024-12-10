import Foundation

DatabaseConnector.setDataBase(dataBase: DatabaseManager.self)
DatabaseConnector.openDataBase()
var mainView = MainView( userController: UserControllerImpl())

mainView.showLoginScreen()
DatabaseConnector.closeDataBase()
