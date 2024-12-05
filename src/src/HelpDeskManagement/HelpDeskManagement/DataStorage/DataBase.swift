//
//  DataBase.swift
//  HelpDeskManagement
//
//  Created by incubation on 05/12/24.
//

protocol DataBase {
    func createTable(createTableQuery: String) throws
    func insertRecord(query: String)throws -> Result<Void, DatabaseError>
    func executeQueryData(query: String)throws -> Result< [[String: Any]], DatabaseError>
}
