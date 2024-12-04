//
//  KnowledgeBaseDAOImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 27/11/24.
//

import Foundation
import SQLite3


class KnowledgeBaseDAOImpl : KnowledgeBaseDAO {
    
    let dbConnector = DatabaseManager.shared.db
    
    init() {
        do {
            try createTable()
        } catch let error {
            print("Error during table creation: \(error)")
        }
    }

    internal func createTable() throws {
        if sqlite3_exec(dbConnector, Queries.createKnowledgeBadeTable, nil, nil, nil) != SQLITE_OK {
            throw DatabaseError.tableCreationFailed("Users table creation failed. Error: \(String(cString: sqlite3_errmsg(dbConnector)))")
        }
    }
    
    func addEntry(entry: KnowledgeBase) -> Result<Void, DatabaseError> {
        let query = Queries.addKnowledgeBaseEntry
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare INSERT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        
        defer { sqlite3_finalize(statement) }
        
        guard let title = entry.titleproperty.cString(using: .utf8),
              let issue = entry.issueProperty.rawValue.cString(using: .utf8),
              let solution = entry.solutionProperty.cString(using: .utf8) else {
            return .failure(.executionFailed("One or more input values are nil or invalid."))
        }
        
        guard sqlite3_bind_text(statement, 1, title, -1, nil) == SQLITE_OK else {
            return .failure(.executionFailed("Failed to bind title. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        guard sqlite3_bind_text(statement, 2, issue, -1, nil) == SQLITE_OK else {
            return .failure(.executionFailed("Failed to bind issue. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        guard sqlite3_bind_text(statement, 3, solution, -1, nil) == SQLITE_OK else {
            return .failure(.executionFailed("Failed to bind solution. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        guard sqlite3_bind_int(statement, 4, Int32(entry.getUserId)) == SQLITE_OK else {
            return .failure(.executionFailed("Failed to bind userId. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
        
        if sqlite3_step(statement) == SQLITE_DONE {
            return .success(())
        } else {
            return .failure(.executionFailed("Failed to insert entry. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
    }
    
    func getAllEntries() -> Result<[KnowledgeBase], DatabaseError> {
        let query = Queries.getAllKnowledgeBaseEntries
        var statement: OpaquePointer?
        var entries: [KnowledgeBase] = []
            
        guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
            return .failure(.preparationFailed("Failed to prepare INSERT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
        }
            
            defer { sqlite3_finalize(statement) }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let title = String(cString: sqlite3_column_text(statement, 1))
                let issueTypeRaw = String(cString: sqlite3_column_text(statement, 2))
                let solution = String(cString: sqlite3_column_text(statement, 3))
                let createdDateString = String(cString: sqlite3_column_text(statement, 4))
                let lastUpdatedDateString = sqlite3_column_text(statement, 5) != nil ? String(cString: sqlite3_column_text(statement, 5)) : nil
                let userId = Int(sqlite3_column_int(statement, 6))
                
                guard let issueType = IssueType(rawValue: issueTypeRaw) else {
                    return .failure(.executionFailed("Invalid issue type: \(issueTypeRaw)"))
                }
                
                guard let createdDate = dateFormatter.date(from: createdDateString) else {
                    return .failure(.executionFailed("Invalid created date: \(createdDateString)"))
                }
                
                let lastUpdatedDate = lastUpdatedDateString.flatMap { dateFormatter.date(from: $0) }
                
                let entry = KnowledgeBase(id: id, title: title, issueType: issueType, solution: solution, createdDate: createdDate, lastUpdatedDate: lastUpdatedDate!, userId: userId)
                
                entries.append(entry)
            }
            
            if sqlite3_errcode(dbConnector) != SQLITE_OK && sqlite3_errcode(dbConnector) != SQLITE_DONE {
                return .failure(.executionFailed("Failed to fetch entries. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
            }
            
            return .success(entries)
        }

    
    func updateEntry(id: Int, solution: String, lastUpdatedDate: Date?) -> Result<Void, DatabaseError> {
            let query = Queries.updateKnowledgeBaseEntry
            var statement: OpaquePointer?

            guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
                return .failure(.preparationFailed("Failed to prepare UPDATE statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
            }

            sqlite3_bind_text(statement, 1, solution.cString(using: .utf8), -1, nil)
            
            if let lastUpdatedDate = lastUpdatedDate {
                let lastUpdatedDateString = ISO8601DateFormatter().string(from: lastUpdatedDate)
                sqlite3_bind_text(statement, 2, lastUpdatedDateString.cString(using: .utf8), -1, nil)
            } else {
                sqlite3_bind_null(statement, 2)
            }
            
            sqlite3_bind_int(statement, 3, Int32(id))

            if sqlite3_step(statement) == SQLITE_DONE {
                sqlite3_finalize(statement)
                return .success(())
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(dbConnector))
                sqlite3_finalize(statement)
                return .failure(.executionFailed("Failed to update entry. Error: \(errorMessage)"))
            }
    }
    
    func getKnowledgeBaseEntryById(id: Int) -> Result<KnowledgeBase, DatabaseError> {
            let query = Queries.getKnowledgeBaseEntryById
            var statement: OpaquePointer?

            guard sqlite3_prepare_v2(dbConnector, query, -1, &statement, nil) == SQLITE_OK else {
                return .failure(.preparationFailed("Failed to prepare SELECT statement. Error: \(String(cString: sqlite3_errmsg(dbConnector)))"))
            }

            sqlite3_bind_int(statement, 1, Int32(id))

            if sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let title = String(cString: sqlite3_column_text(statement, 1))
                let issueTypeRaw = String(cString: sqlite3_column_text(statement, 2))
                let solution = String(cString: sqlite3_column_text(statement, 3))
                let createdDateString = String(cString: sqlite3_column_text(statement, 4))
                let lastUpdatedDateString = sqlite3_column_text(statement, 5) != nil ? String(cString: sqlite3_column_text(statement, 5)) : nil
                let userId = Int(sqlite3_column_int(statement, 6))
                
                guard let issueType = IssueType(rawValue: issueTypeRaw),
                      let createdDate = ISO8601DateFormatter().date(from: createdDateString) else {
                    sqlite3_finalize(statement)
                    return .failure(.executionFailed("Failed to parse data for entry ID \(id)."))
                }
                
                let lastUpdatedDate = lastUpdatedDateString != nil ? ISO8601DateFormatter().date(from: lastUpdatedDateString!) : nil
                let entry = KnowledgeBase(id: id, title: title, issueType: issueType, solution: solution, createdDate: createdDate, lastUpdatedDate: lastUpdatedDate ?? Date(), userId: userId)

                sqlite3_finalize(statement)
                return .success(entry)
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(dbConnector))
                sqlite3_finalize(statement)
                return .failure(.executionFailed("Failed to retrieve entry. Error: \(errorMessage)"))
            }
    }
        
}
