import Foundation

var dataBase : DataBase = DatabaseManager()
var mainView = MainView( userController: UserControllerImpl(dataBase: dataBase), dataBase: dataBase)

mainView.showLoginScreen()
