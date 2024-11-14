//
//  Loggable.swift
//  HelpDeskManagement
//
//  Created by incubation on 14/11/24.
//

protocol Loggable {
    var logType: LogType { get }
    var logMessage: String { get }
    var logId: Int { get }
}
