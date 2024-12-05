//
//  LogsEntryController.swift
//  HelpDeskManagement
//
//  Created by incubation on 05/12/24.
//

protocol LogsEntryController :  AnyObject {
    func log<T: Loggable>(logType: LogType, message: String, userId: Int, data : T) throws -> Bool
}
