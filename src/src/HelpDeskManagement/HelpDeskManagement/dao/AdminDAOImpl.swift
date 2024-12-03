//
//  AdminDAOImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 27/11/24.
//
import SQLite3
import Foundation

class AdminDAOImpl : AdminDAO {
    
    let dbConnector = DatabaseManager.shared.db
    
    init() {
        do {
            try createTable()
        } catch let error {
            print("Error during table creation: \(error)")
        }
    }

    internal func createTable() throws {
        if sqlite3_exec(dbConnector, Queries.createAdminTable, nil, nil, nil) != SQLITE_OK {
            throw DatabaseError.tableCreationFailed("Users table creation failed. Error: \(String(cString: sqlite3_errmsg(dbConnector)))")
        }
        print("Admin table created successfully (or already exists).")
    }
    
    func setDefaultpassword(passwordState: Bool, adminId: Int) -> Result<Void, DatabaseError> {
        let query = Queries.updateDefaultPassword
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare UPDATE statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        
        sqlite3_bind_int(statement, 1, passwordState ? 1 : 0)
        sqlite3_bind_int(statement, 2, Int32(adminId))

        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_finalize(statement)
            return .success(())
        } else {
            sqlite3_finalize(statement)
            return .failure(.executionFailed("Failed to update password state. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
    }
    
    func updatePassword(user: Admin, password: String) -> Result<Void, DatabaseError>  {
        let query = Queries.updatePassword
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare UPDATE statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }

        sqlite3_bind_text(statement, 1, (password as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 2, Int32(user.getUserId))

        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_finalize(statement)
            return .success(())
        } else {
            sqlite3_finalize(statement)
            return .failure(.executionFailed("Failed to update password. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
    }

    
}
