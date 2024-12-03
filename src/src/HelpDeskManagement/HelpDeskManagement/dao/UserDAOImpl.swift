//
//  UserDAOImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 26/11/24.
//
import SQLite3
import Foundation

class UserDAOImpl: UserDAO {
    let dbConnector = DatabaseManager.shared.db

    init() {
        do {
            try createTable()
        } catch let error {
            print("Error during table creation: \(error)")
        }
    }

    internal func createTable() throws {
        if sqlite3_exec(dbConnector, Queries.createUserTable, nil, nil, nil) != SQLITE_OK {
            throw DatabaseError.tableCreationFailed("Users table creation failed. Error: \(String(cString: sqlite3_errmsg(dbConnector)))")
        }
        print("Users table created successfully (or already exists).")
    }

    func getUserById(userId: Int) -> Result<User, DatabaseError> {
        let query = Queries.getUserById
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }

        sqlite3_bind_int(statement, 1, Int32(userId))

        if sqlite3_step(statement) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(statement, 0))
            let name = String(cString: sqlite3_column_text(statement, 1))
                     let roleRawValue = String(cString: sqlite3_column_text(statement, 2))
                     sqlite3_finalize(statement)
            
            if let role = Role(rawValue: roleRawValue) {
                return .success(User(id: id, name: name, role: role))
            } else {
                return .failure(.executionFailed("Invalid role value retrieved from database."))
            }
        } else {
            sqlite3_finalize(statement)
            return .failure(.noRecordFound("No user found with ID \(userId)."))
        }
    }

    func changePassword(user: User, newPassword: String) -> Result<Void, DatabaseError> {
        let query = Queries.updatePassword
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare UPDATE statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }

        sqlite3_bind_text(statement, 1, (newPassword as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 2, Int32(user.getId))

        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_finalize(statement)
            return .success(())
        } else {
            sqlite3_finalize(statement)
            return .failure(.executionFailed("Failed to update password. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
    }

    func addUser(user: User) -> Result<Void, DatabaseError> {
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(dbConnector, Queries.addUser, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare INSERT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }

        sqlite3_bind_text(statement, 1, (user.getName as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, (user.getRole.rawValue as NSString).utf8String, -1, nil)

        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_finalize(statement)
            return .success(())
        } else {
            sqlite3_finalize(statement)
            return .failure(.executionFailed("Failed to insert user. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
    }

    func getAllUsers() -> Result<[User], DatabaseError> {
        let query = Queries.getAllUsers
        var statement: OpaquePointer?
        var users: [User] = []

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }

        while sqlite3_step(statement) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(statement, 0))
            let name = String(cString: sqlite3_column_text(statement, 1))
            let roleRawValue = String(cString: sqlite3_column_text(statement, 2))
            if let role = Role(rawValue: roleRawValue) {
                let user = User(id: id, name: name, role: role)
                users.append(user)
            }
        }

        sqlite3_finalize(statement)
        return .success(users)
    }
    
    func addUsersUserNamePassword(userName : String, password : String, user : User) -> Result<Void, DatabaseError> {
        let query = Queries.addUserNameAndPassword
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        
        sqlite3_bind_text(statement, 1, (userName as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, (password as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 3, Int32(user.getId))

        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_finalize(statement)
            return .success(())
        } else {
            sqlite3_finalize(statement)
            return .failure(.executionFailed("Failed to insert user. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
    }
    
    func getUserNameAndPassword (userId : Int) -> Result<[String], DatabaseError> {
        let query = Queries.getUserNameAndPassword
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        print("User Id : \(userId)")
        sqlite3_bind_int(statement, 1, Int32(userId))
        
        if sqlite3_step(statement) == SQLITE_ROW {
            let userName = String(cString: sqlite3_column_text(statement, 0))
            let password = String(cString: sqlite3_column_text(statement, 1))
            sqlite3_finalize(statement)
            return .success([userName, password])
        } else {
            sqlite3_finalize(statement)
            return .failure(.noRecordFound("No user found for user with ID \(userId)."))
        }
    }
    
    func getUserRole(userName: String, password: String) -> Result<(String, Int), DatabaseError> {
        let query = Queries.getuserRole
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }

        sqlite3_bind_text(statement, 1, (userName as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, (password as NSString).utf8String, -1, nil)

        if sqlite3_step(statement) == SQLITE_ROW {
            
            guard let rolePointer = sqlite3_column_text(statement, 0) else {
                sqlite3_finalize(statement)
                return .failure(.executionFailed("Role column is NULL."))
            }
            let role = String(cString: rolePointer)
            let userId = Int(sqlite3_column_int(statement, 1))
            sqlite3_finalize(statement)
            return .success((role, userId))
        } else {
            sqlite3_finalize(statement)
            return .failure(.noRecordFound("No user found for the provided username and password."))
        }
    }
    
    func getAgentByUserId(userId : Int) -> Result<Agent?, DatabaseError> {
        let query = Queries.getAgentByUserId
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }

        sqlite3_bind_int(statement, 1, Int32(userId))
        
        if sqlite3_step(statement) == SQLITE_ROW {
            let agentId = Int(sqlite3_column_int(statement, 0))
            let department = String(cString: sqlite3_column_text(statement, 1))
            let availabiltyStatus = String(cString: sqlite3_column_text(statement, 2))
            let ticketResolvedCount = Int(sqlite3_column_int(statement, 3))
            let userId = Int(sqlite3_column_int(statement, 4))
            let name = String(cString: sqlite3_column_text(statement, 5))
            sqlite3_finalize(statement)
            return .success(Agent(id: agentId, name: name, department: department, status: AgentStatus(rawValue: availabiltyStatus) ?? AgentStatus.available, ticketResolved: ticketResolvedCount, userId: userId))
        } else {
            sqlite3_finalize(statement)
            return .failure(.noRecordFound("No agent found for UserID \(userId)."))
        }
    }
    
    func getAdminByUserId(userId : Int) -> Result<Admin?, DatabaseError> {
        let query = Queries.getAdminByUserId
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }

        sqlite3_bind_int(statement, 1, Int32(userId))
        
        if sqlite3_step(statement) == SQLITE_ROW {
            let adminId = Int(sqlite3_column_int(statement, 0))
            let hasDefaultPassword = sqlite3_column_int(statement, 1) != 0
            let userId = Int(sqlite3_column_int(statement, 2))
            let name = String(cString: sqlite3_column_text(statement, 3))
            sqlite3_finalize(statement)
            return .success(Admin(name: name, userRole: nil, role: Role.admin, userId: userId, hasDefaultPassword: hasDefaultPassword))
        } else {
            sqlite3_finalize(statement)
            return .failure(.noRecordFound("No agent found for UserID \(userId)."))
        }
    }
    
    func getLastCreatedUserId() -> Result<Int, DatabaseError> {
        let query = Queries.getLastUserId
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        if sqlite3_step(statement) == SQLITE_ROW {
            let userId = Int(sqlite3_column_int(statement, 0))
            return .success(userId)
        }
        else {
            return .failure(.noRecordFound("No userId Found"))
        }
        
    }

}
