//
//  DataBase.swift
//  HelpDeskManagement
//
//  Created by incubation on 05/12/24.
//

protocol DataBase {
    static func openDataBase()
    static func createTable(createTableQuery: String) throws
    static func insertRecord(query: String) throws -> Result<Void, DatabaseError>
    static func executeQueryData(query: String) throws -> Result<[[String: Any]], DatabaseError>
    static func closeDataBase()
}
