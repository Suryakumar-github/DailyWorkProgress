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
    private var additionalInfo: [String: String]?
    private var logCount = 0
    
    init(timestamp: Date, logType: LogType, message: String, userId: Int? = nil, additionalInfo: [String : String]? = nil) {
        logCount += 1
        self.id = logCount
        self.timestamp = timestamp
        self.logType = logType
        self.message = message
        self.userId = userId
        self.additionalInfo = additionalInfo
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
            if let newAdditionalInfo = additionalInfo {
                return newAdditionalInfo
            }
            else {
                return nil
            }
        }
        set(newAdditionalInfo) {
            additionalInfo = newAdditionalInfo
        }
    }
    
}
