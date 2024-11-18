//
//  Logs.swift
//  HelpDeskManagement
//
//  Created by incubation on 04/11/24.
//
import Foundation

class LogsEntry {
    
    private let id: Int
    private let timestamp: Date
    private var logType: LogType
    private var message: String
    private var userId: Int?
    private var additionalInfo: [String: String] = [:]
    private static var logCount = 0
    
    init(timestamp: Date, logType: LogType, message: String, userId: Int? = nil, additionalInfo: [String: String]) {
        LogsEntry.logCount += 1
        self.id = LogsEntry.logCount
        self.timestamp = timestamp
        self.logType = logType
        self.message = message
        self.userId = userId
    }
    convenience init(timestamp: Date, logType: LogType, message: String, userId: Int?) {
        self.init(timestamp: timestamp, logType: logType, message: message, userId: userId, additionalInfo: [:])
    }
    
    var getId : Int {
        return id
    }
    var getTimestamp : Date {
        return timestamp
    }
    
    var logtypeProperty : LogType {
        get {
            return logType
        }
        set(newLogType) {
            logType = newLogType
        }
    }
    
    var messageProperty : String {
        get {
            return message
        }
        set(newMessage) {
            message = newMessage
        }
    }
    var getUserId : Int? {
        if let newUserid = userId {
            return newUserid
        }
        else {
            return nil
        }
    }
    var additionalInfoProperty : [String : String]? {
        get {
            return additionalInfo
            }
        set(newAdditionalInfo) {
            additionalInfo = newAdditionalInfo ?? [:]
        }
    }
    deinit{
        
    }
}
