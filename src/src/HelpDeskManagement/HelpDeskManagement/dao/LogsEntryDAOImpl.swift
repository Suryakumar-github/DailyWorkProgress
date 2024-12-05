//
//  LogsEntryDAOImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 27/11/24.
//
import Foundation

class LogsEntryDAOImpl : LogsEntryDAO {
    
    var dataBase : DataBase
    init(dataBase : DataBase) {
        self.dataBase = dataBase
        do{
            try dataBase.createTable(createTableQuery: Queries.createLogsEntryTable)
        }
        catch {
            print("Error : \(error)")
        }
    }
    
    func getAllLogsEntry()throws -> Result<[LogsEntry], DatabaseError> {
        let query = "SELECT * FROM LogsEntry"
            
        let result = try dataBase.executeQueryData(query: query)
            
            switch result {
            case .success(let logs):
                let ticketList = logs.compactMap { row -> LogsEntry? in
                    guard let log_id = row["log_id"] as? Int,
                          let userId = row["user_id"] as? Int,
                          let message = row["message"] as? String,
                          let createdDateString = row["timestamp"] as? String,
                          let logType = row["logType"] as? String
                    else {
                        return nil
                    }
                    
                    let createdDate: Date
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                    
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let parsedDate = dateFormatter.date(from: createdDateString)
                        
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
                    
                    return LogsEntry(id: log_id, timestamp: parsedDate ?? Date(), logType: LogType(rawValue: logType) ?? LogType.info, message: message, userId: userId)
                }
                
                return .success(ticketList)
                
            case .failure(let error):
                return .failure(error)
            }
    }
    
    
    func addLogsEntry(logsEntry: LogsEntry) -> Result<Void, DatabaseError> {
        let query = "INSERT INTO LogsEntry (user_id,message,logType) VALUES (?,?,?)"
        
        let data: [Any] = [
            logsEntry.getUserId!,
            logsEntry.messageProperty,
            logsEntry.logtypeProperty.rawValue
        ]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            
            return try dataBase.insertRecord(query: finalQuery)
        } catch let error as DatabaseError {
            return .failure(error)
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    

    func getLogsEntryByDate(date : Date)throws -> Result<[LogsEntry], DatabaseError> {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDateString = dateFormatter.string(from: date)

        let query = "SELECT * FROM LogsEntry WHERE DATE(timestamp) = '\(formattedDateString)';"
        let result = try dataBase.executeQueryData(query: query)
        
        switch result {
        case .success(let logs):
            let ticketList = logs.compactMap { row -> LogsEntry? in
                guard let log_id = row["log_id"] as? Int,
                      let userId = row["user_id"] as? Int,
                      let message = row["message"] as? String,
                      let createdDateString = row["timestamp"] as? String,
                      let logType = row["logType"] as? String
                else {
                    return nil
                }
                
                let createdDate: Date
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let parsedDate = dateFormatter.date(from: createdDateString)
                    
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
                
                return LogsEntry(id: log_id, timestamp: parsedDate ?? Date(), logType: LogType(rawValue: logType) ?? LogType.info, message: message, userId: userId)
            }
            
            return .success(ticketList)
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getLogsEntryBetweenDates(date1 : Date, date2 : Date)throws -> Result<[LogsEntry], DatabaseError> {
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let formattedDateString1 = dateFormatter1.string(from: date1)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        let formattedDateString2 = dateFormatter2.string(from: date2)
        
        let query = "SELECT * FROM LogsEntry WHERE DATE(timestamp) BETWEEN '\(formattedDateString1)' AND '\(formattedDateString2)';"

        let result = try dataBase.executeQueryData(query: query)
        
        switch result {
        case .success(let logs):
            let ticketList = logs.compactMap { row -> LogsEntry? in
                guard let log_id = row["log_id"] as? Int,
                      let userId = row["user_id"] as? Int,
                      let message = row["message"] as? String,
                      let createdDateString = row["timestamp"] as? String,
                      let logType = row["logType"] as? String
                else {
                    return nil
                }
                
                let createdDate: Date
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let parsedDate = dateFormatter.date(from: createdDateString)
                    
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
                
                return LogsEntry(id: log_id, timestamp: parsedDate ?? Date(), logType: LogType(rawValue: logType) ?? LogType.info, message: message, userId: userId)
            }
            
            return .success(ticketList)
            
        case .failure(let error):
            return .failure(error)
        }
    }

    
}
