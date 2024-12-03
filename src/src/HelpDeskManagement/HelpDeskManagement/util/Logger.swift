//
//  Logger.swift
//  HelpDeskManagement
//
//  Created by incubation on 14/11/24.
//

import Foundation

class Logger {
    private static let logsEntryDao : LogsEntryDAO = LogsEntryDAOImpl()
    
    static func log<T: Loggable>(logType: LogType, message: String, userId: Int, data : T) throws {
        let logEntry = LogsEntry(timestamp: Date(), logType: logType, message: message, userId: userId)
        let result = logsEntryDao.addLogsEntry(logsEntry: logEntry)
        switch result {
        case .success() :
            print()
        case .failure(let error) :
            throw error
        }
    }
    
    static func getItemById<T>(from dictionary: [Int: T], id: Int) -> T? {
        return dictionary[id]
    }

    deinit{
        
    }
}
