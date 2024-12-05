//
//  LogsEntryControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 05/12/24.
//

import Foundation

class LogsEntryControllerImpl : LogsEntryController {
    private var dataBase : DataBase
    private var logsEntryDao : LogsEntryDAO
    
    init(dataBase: DataBase) {
        self.dataBase = dataBase
        self.logsEntryDao = LogsEntryDAOImpl(dataBase: dataBase)
    }
    
    func log<T: Loggable>(logType: LogType, message: String, userId: Int, data : T) throws -> Bool {
        let logEntry = LogsEntry(timestamp: Date(), logType: logType, message: message, userId: userId)
        let result = logsEntryDao.addLogsEntry(logsEntry: logEntry)
        switch result {
        case .success() :
            return true
        case .failure(let error) :
            throw error
        }
    }
}
