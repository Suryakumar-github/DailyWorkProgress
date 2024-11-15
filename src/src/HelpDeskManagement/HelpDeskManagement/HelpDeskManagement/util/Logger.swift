//
//  Logger.swift
//  HelpDeskManagement
//
//  Created by incubation on 14/11/24.
//

import Foundation

class Logger {
    
    static func log<T: Loggable>(logType: LogType, message: String, userId: Int, data : T) {
        let logEntry = LogsEntry(timestamp: Date(), logType: logType, message: message, userId: userId)
        DataStorage.allLogsEntry[logEntry.getId] = logEntry
    }
    
    static func getItemById<T>(from dictionary: [Int: T], id: Int) -> T? {
        return dictionary[id]
    }

}
