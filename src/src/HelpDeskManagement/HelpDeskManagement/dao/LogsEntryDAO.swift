//
//  LogsEntryDAO.swift
//  HelpDeskManagement
//
//  Created by incubation on 27/11/24.
//

import Foundation

protocol LogsEntryDAO {
    func addLogsEntry(logsEntry : LogsEntry) -> Result<Void, DatabaseError>
    func getAllLogsEntry()throws -> Result<[LogsEntry], DatabaseError>
    func getLogsEntryByDate(date : Date)throws -> Result<[LogsEntry], DatabaseError>
    func getLogsEntryBetweenDates(date1 : Date, date2 : Date)throws -> Result<[LogsEntry], DatabaseError>
}
