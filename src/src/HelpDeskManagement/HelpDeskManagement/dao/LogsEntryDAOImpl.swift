//
//  LogsEntryDAOImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 27/11/24.
//
import Foundation
import SQLite3

class LogsEntryDAOImpl : LogsEntryDAO {
    
    let dbConnector = DatabaseManager.shared.db
    
    init() {
        do {
            try createTable()
        } catch let error {
            print("Error during table creation: \(error)")
        }
    }

    internal func createTable() throws {
        if sqlite3_exec(dbConnector, Queries.createLogsEntryTable, nil, nil, nil) != SQLITE_OK {
            throw DatabaseError.tableCreationFailed("Users table creation failed. Error: \(String(cString: sqlite3_errmsg(dbConnector)))")
        }
        
    }
    
    func addLogsEntry(logsEntry: LogsEntry) -> Result<Void, DatabaseError> {
        let query = Queries.addLogEntry
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare INSERT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }

        sqlite3_bind_int(statement, 1, Int32(logsEntry.getUserId!))
        sqlite3_bind_text(statement, 2, (logsEntry.messageProperty as NSString).utf8String, -1, nil) 
        sqlite3_bind_text(statement, 3, (logsEntry.logtypeProperty.rawValue as NSString).utf8String, -1, nil)

        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_finalize(statement)
            return .success(())
        } else {
            sqlite3_finalize(statement)
            return .failure(.executionFailed("Failed to enter Logs. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
    }
    
    func getAllLogsEntry() -> Result<[LogsEntry], DatabaseError> {
        let query = Queries.getAllLogsEntry
        var statement: OpaquePointer?
        var entries: [LogsEntry] = []

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }

        while sqlite3_step(statement) == SQLITE_ROW {
            let logId = Int(sqlite3_column_int(statement, 0))
            let userId = Int(sqlite3_column_int(statement, 1))
            let message = String(cString: sqlite3_column_text(statement, 2))
            let createdDateString = String(cString: sqlite3_column_text(statement, 3))
            let logType = String(cString: sqlite3_column_text(statement, 4))

            let createdDate: Date
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var parsedDate = dateFormatter.date(from: createdDateString)
                
            if parsedDate == dateFormatter.date(from: createdDateString) {
                
            }  else {
                print("Failed to parse date with format: yyyy-MM-dd HH:mm:ss. Trying alternative formats.")

                
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let parsedDate = dateFormatter.date(from: createdDateString) {
                    createdDate = Calendar.current.startOfDay(for: parsedDate)
                } else {
                    print("All parsing attempts failed. Using current date as fallback.")
                    createdDate = Date()
                }
            }

            let entry = LogsEntry(
                id: logId,
                timestamp: parsedDate!,
                logType: LogType(rawValue: logType) ?? LogType.info,
                message: message,
                userId: userId
            )
            entries.append(entry)
        }

        sqlite3_finalize(statement)
        return .success(entries)
    }

    func getLogsEntryByDate(date : Date) -> Result<[LogsEntry], DatabaseError> {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDateString = dateFormatter.string(from: date)

        let query = "SELECT * FROM LogsEntry WHERE DATE(timestamp) = '\(formattedDateString)';"
        var statement: OpaquePointer?
        var entries: [LogsEntry] = []

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let logId = Int(sqlite3_column_int(statement, 0))
            let userId = Int(sqlite3_column_int(statement, 1))
            let message = String(cString: sqlite3_column_text(statement, 2))
            let createdDateString = String(cString: sqlite3_column_text(statement, 3))
            let logType = String(cString: sqlite3_column_text(statement, 4))

            let createdDate: Date
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var parsedDate = dateFormatter.date(from: createdDateString)
                
            if parsedDate == dateFormatter.date(from: createdDateString) {
                
            }  else {
                print("Failed to parse date with format: yyyy-MM-dd HH:mm:ss. Trying alternative formats.")

                
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let parsedDate = dateFormatter.date(from: createdDateString) {
                    createdDate = Calendar.current.startOfDay(for: parsedDate)
                } else {
                    print("All parsing attempts failed. Using current date as fallback.")
                    createdDate = Date()
                }
            }

            let entry = LogsEntry(
                id: logId,
                timestamp: parsedDate!,
                logType: LogType(rawValue: logType) ?? LogType.info,
                message: message,
                userId: userId
            )
            entries.append(entry)
        }

        sqlite3_finalize(statement)
        return .success(entries)
    }
    
    func getLogsEntryBetweenDates(date1 : Date, date2 : Date) -> Result<[LogsEntry], DatabaseError> {
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let formattedDateString1 = dateFormatter1.string(from: date1)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        let formattedDateString2 = dateFormatter2.string(from: date2)
        
        let query = "SELECT * FROM LogsEntry WHERE DATE(timestamp) BETWEEN '\(formattedDateString1)' AND '\(formattedDateString2)';"

        var statement: OpaquePointer?
        var entries: [LogsEntry] = []

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let logId = Int(sqlite3_column_int(statement, 0))
            let userId = Int(sqlite3_column_int(statement, 1))
            let message = String(cString: sqlite3_column_text(statement, 2))
            let createdDateString = String(cString: sqlite3_column_text(statement, 3))
            let logType = String(cString: sqlite3_column_text(statement, 4))

            let createdDate: Date
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var parsedDate = dateFormatter.date(from: createdDateString)
                
            if parsedDate == dateFormatter.date(from: createdDateString) {
                
            }  else {
                print("Failed to parse date with format: yyyy-MM-dd HH:mm:ss. Trying alternative formats.")

                
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let parsedDate = dateFormatter.date(from: createdDateString) {
                    createdDate = Calendar.current.startOfDay(for: parsedDate)
                } else {
                    print("All parsing attempts failed. Using current date as fallback.")
                    createdDate = Date()
                }
            }

            let entry = LogsEntry(
                id: logId,
                timestamp: parsedDate!,
                logType: LogType(rawValue: logType) ?? LogType.info,
                message: message,
                userId: userId
            )
            entries.append(entry)
        }

        sqlite3_finalize(statement)
        return .success(entries)
        
    }

    
}
