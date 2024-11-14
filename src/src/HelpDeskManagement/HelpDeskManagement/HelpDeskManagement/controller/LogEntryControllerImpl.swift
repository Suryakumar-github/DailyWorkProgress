//
//  LogEntryControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//
import Foundation

class LogEntryControllerImpl : LogEntryController {
    
    func createLogEntry(logId: Int, timestamp: Date, logType: LogType, message: String, userId: Int?, additionalInfo: [String : String]?) {
        let logEntry = LogsEntry( timestamp: timestamp, logType: logType, message: message, userId: userId)
        DataStorage.allLogsEntry[logId] = logEntry
    }
    
    func fetchLogEntry(logId: Int, logType: LogType) -> LogsEntry? {
        if let logEntry = getLogEntryById(logId: logId) {
            return logEntry
        }
        return nil
    }
    
    func getLogEntryById(logId: Int) -> LogsEntry? {
        let logEntries = DataStorage.allLogsEntry
        if let logEntry = logEntries[logId] {
            return logEntry
        }
        return nil
    }
}
