//
//  LogentryController.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//
import Foundation

protocol LogEntryController : AnyObject{
    func createLogEntry(logId: Int, timestamp: Date, logType: LogType, message: String, userId: Int?, additionalInfo: [String: String]?)
    func fetchLogEntry(logId : Int, logType: LogType) -> LogsEntry?
}
