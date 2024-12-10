//
//  AdminDAOImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 27/11/24.
//
import Foundation

class AdminDAOImpl : AdminDAO {
    
    init()  {
       
        do{
            try  DatabaseConnector.createTable(createTableQuery: Queries.createAdminTable)
        }
        catch {
            print("Error : \(error)")
        }
    }
    
    func getUserNameAndPassword(userId: Int)  -> Result<[String], DatabaseError> {
        let query = "SELECT userName, password FROM userNameAndPasswords WHERE userId = ?;"
        let data: [Any] = [userId]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            
            let result = try  DatabaseConnector.executeQueryData(query: finalQuery)
            
            switch result {
            case .success(let usersData):
                let credentials = usersData.compactMap { userDict -> [String]? in
                    guard let userName = userDict["userName"] as? String,
                          let password = userDict["password"] as? String else {
                        return nil
                    }
                    return [userName, password]
                }
                
                return .success(credentials.flatMap { $0 })
                
            case .failure(let error):
                return .failure(error)
            }
            
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func setDefaultpassword(passwordState: Bool, adminId: Int)  -> Result<Void, DatabaseError> {
        let query = "UPDATE admin SET hasDefaultPassword = ? WHERE userId = ?"
        let data: [Any] = [
            adminId
        ]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            return try  DatabaseConnector.insertRecord(query: finalQuery)
        } catch let error as DatabaseError {
            return .failure(error)
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func updatePassword(user: Admin, password: String)  -> Result<Void, DatabaseError>  {
        let query = "UPDATE userNameAndPasswords SET password = ? where userId = ?;"
        
        let data: [Any] = [
            password,
            user.getUserId
        ]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            return try  DatabaseConnector.insertRecord(query: finalQuery)
        } catch let error as DatabaseError {
            return .failure(error)
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
}
