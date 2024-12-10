//
//  DataBase.swift
//  HelpDeskManagement
//
//  Created by incubation on 05/12/24.
//

import Foundation
import SQLite3

class DatabaseManager: DataBase {
    private static var db: OpaquePointer?

    static func openDataBase()  {
        let fileManager = FileManager.default
        let documentDirectory = try? fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        guard let dbPath = documentDirectory?.appendingPathComponent("HelpDeskManagement.db").path else {
            db = nil
            print("Unable to resolve database path.")
            return
        }

        var database: OpaquePointer?
        if sqlite3_open(dbPath, &database) == SQLITE_OK {
            db = database
            print("Successfully connected to database at \(dbPath)")
        } else {
            db = nil
            print("Unable to open database at \(dbPath). Error: \(String(cString: sqlite3_errmsg(database)))")
        }
    }

    static func createTable(createTableQuery: String)  throws {
        var createTableStatement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStatement, nil) == SQLITE_OK else {
            let errorMsg = String(cString: sqlite3_errmsg(db))
            throw DatabaseError.preparationFailed("Error preparing create table statement: \(errorMsg)")
        }
        
        guard sqlite3_step(createTableStatement) == SQLITE_DONE else {
            let errorMsg = String(cString: sqlite3_errmsg(db))
            sqlite3_finalize(createTableStatement)
            throw DatabaseError.tableCreationFailed("Error executing create table statement: \(errorMsg)")
        }
        
        sqlite3_finalize(createTableStatement)
    }

    static func insertRecord(query: String)  throws -> Result<Void, DatabaseError> {
        var insertStatement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db, query, -1, &insertStatement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare INSERT statement. Error: \(String(cString: sqlite3_errmsg(db)))"))
        }
        
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            let errorMsg = String(cString: sqlite3_errmsg(db))
            sqlite3_finalize(insertStatement)
            return .failure(.executionFailed("Error inserting record: \(errorMsg)"))
        }
        
        sqlite3_finalize(insertStatement)
        return .success(())
    }

    static func executeQueryData(query: String)  throws -> Result<[[String: Any]], DatabaseError> {
        var result = [[String: Any]]()
        var queryStatement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK else {
            let errorMsg = String(cString: sqlite3_errmsg(db))
            return .failure(.preparationFailed("Error preparing query: \(errorMsg)"))
        }
        
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            let columnCount = sqlite3_column_count(queryStatement)
            var row = [String: Any]()
            
            for columnIndex in 0..<columnCount {
                if let columnName = sqlite3_column_name(queryStatement, columnIndex) {
                    let columnString = String(cString: columnName)
                    
                    switch sqlite3_column_type(queryStatement, columnIndex) {
                    case SQLITE_TEXT:
                        if let columnText = sqlite3_column_text(queryStatement, columnIndex) {
                            row[columnString] = String(cString: columnText)
                        }
                    case SQLITE_INTEGER:
                        row[columnString] = Int(sqlite3_column_int(queryStatement, columnIndex))
                    case SQLITE_FLOAT:
                        row[columnString] = sqlite3_column_double(queryStatement, columnIndex)
                    case SQLITE_NULL:
                        row[columnString] = nil
                    default:
                        break
                    }
                }
            }
            result.append(row)
        }
        
        sqlite3_finalize(queryStatement)
        return .success(result)
    }

    static func closeDataBase()  {
        if let database = db {
            if sqlite3_close(database) == SQLITE_OK {
                print("Database closed successfully.")
            } else {
                print("Error closing database: \(String(cString: sqlite3_errmsg(database)))")
            }
            db = nil
        }
    }
}
