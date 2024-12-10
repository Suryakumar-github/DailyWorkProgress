//
//  DataBaseConnector.swift
//  HelpDeskManagement
//
//  Created by incubation on 09/12/24.
//

import Foundation

class DatabaseConnector : DataBase {
   
    private static var database: DataBase.Type? = nil
    
    static func setDataBase(dataBase : DataBase.Type) {
        self.database = dataBase
    }
    
    static func openDataBase() {
        database?.openDataBase()
    }
    
    
    static func createTable(createTableQuery: String)  throws {
        guard let database = database else {
            throw DatabaseError.executionFailed("Database is not initialized. Call openDatabase() first.")
        }
        try  database.createTable(createTableQuery: createTableQuery)
    }


    static func insertRecord(query: String)  throws -> Result<Void, DatabaseError> {
        guard let database = database else {
            throw DatabaseError.executionFailed("Database is not initialized. Call openDatabase() first.")
        }
        return try  database.insertRecord(query: query)
    }

    
    static func executeQueryData(query: String)  throws -> Result<[[String: Any]], DatabaseError> {
        guard let database = database else {
            throw DatabaseError.executionFailed("Database is not initialized. Call openDatabase() first.")
        }
        return try  database.executeQueryData(query: query)
    }
    
    static func closeDataBase() {
        guard let database = database else {
            print("Database is already closed or not initialized.")
            return
        }
        
        database.closeDataBase()
        self.database = nil
    }
}

