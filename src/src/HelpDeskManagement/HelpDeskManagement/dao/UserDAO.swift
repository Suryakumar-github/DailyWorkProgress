//
//  UserDAO.swift
//  HelpDeskManagement
//
//  Created by incubation on 26/11/24.
//

protocol UserDAO {
    func getUserById(userId: Int) -> Result<User, DatabaseError>
    func addUser(user: User) -> Result<Void, DatabaseError>
    func changePassword(user: User, newPassword: String) -> Result<Void, DatabaseError>
    func getAllUsers()throws -> Result<[User], DatabaseError>
    func addUsersUserNamePassword(userName : String, password : String, user : User) -> Result<Void, DatabaseError>
    func getUserNameAndPassword (userId : Int) -> Result<[String], DatabaseError>
    func getUserRole(userName : String, password : String) -> Result<(String, Int), DatabaseError>
    func getLastCreatedUserId() throws -> Result<Int, DatabaseError>
    func getAgentByUserId(userId: Int) -> Result<Agent, DatabaseError>
    func getAdminByUserId(userId: Int) -> Result<Admin?, DatabaseError>
}
