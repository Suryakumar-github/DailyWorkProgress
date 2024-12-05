//
//  KnowledgeBaseDAOImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 27/11/24.
//

import Foundation

class KnowledgeBaseDAOImpl : KnowledgeBaseDAO {
    
    var dataBase : DataBase
    init(dataBase : DataBase) {
        self.dataBase = dataBase
        do{
            try dataBase.createTable(createTableQuery: Queries.createKnowledgeBadeTable)
        }
        catch {
            print("Error : \(error)")
        }
    }
    
    func addEntry(entry: KnowledgeBase) -> Result<Void, DatabaseError> {
        let query = "INSERT INTO KnowledgeBase (title, issue,solution,userId) VALUES (?, ?, ?, ?); "
        
        let data: [Any] = [
            entry.titleproperty,
            entry.issueProperty.rawValue,
            entry.solutionProperty,
            entry.getUserId
        ]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            
            return try dataBase.insertRecord(query: finalQuery)
        } catch let error as DatabaseError {
            return .failure(error)
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
    
    func getAllEntries() throws-> Result<[KnowledgeBase], DatabaseError> {
        let query = "SELECT * FROM KnowledgeBase;"
        
        let result = try dataBase.executeQueryData(query: query)
        
        switch result {
        case .success(let logs):
            let ticketList = logs.compactMap { row -> KnowledgeBase? in
                guard let id = row["kb_id"] as? Int,
                      let title = row["title"] as? String,
                      let issue = row["issue"] as? String,
                      let solution = row["solution"] as? String,
                      let createdDateString = row["created_at"] as? String,
                      let updateDateString = row["updated_at"] as? String,
                      let userId = row["userId"] as? Int
                else {
                    return nil
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let createdDate = dateFormatter.date(from: createdDateString) ?? Date()
                let updateddate = dateFormatter.date(from: updateDateString) ?? Date()
                
                return KnowledgeBase(id: id, title: title, issueType: IssueType(rawValue: issue) ?? IssueType.software, solution: solution, createdDate: createdDate, lastUpdatedDate: updateddate, userId: userId)
            }
            
            return .success(ticketList)
            
        case .failure(let error):
            return .failure(error)
        }
    }

    
    func updateEntry(id: Int, solution: String, lastUpdatedDate: Date?) -> Result<Void, DatabaseError> {
        let query = "UPDATE KnowledgeBase SET solution = ? , updated_at = ? where kb_id = ?"
        
        let data: [Any] = [
            solution,Date(),id
        ]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            
            return try dataBase.insertRecord(query: finalQuery)
        } catch let error as DatabaseError {
            return .failure(error)
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
            
    }
    
    func getKnowledgeBaseEntryById(id: Int) -> Result<KnowledgeBase, DatabaseError> {
        let query = "SELECT * FROM KnowledgeBase where kb_id = ?"
        let data : [Any] = [id]
        
        do {
            let finalQuery = try QueryGenerator.queryGenerator(baseQuery: query, data: data)
            let result = try dataBase.executeQueryData(query: finalQuery)
            switch result {
            case .success(let usersData):
                if let row = usersData.first,
                   let id = row["kb_id"] as? Int,
                   let title = row["title"] as? String,
                   let issue = row["issue"] as? String,
                   let solution = row["solution"] as? String,
                   let createdDateString = row["created_at"] as? String,
                   let updateDateString = row["updated_at"] as? String,
                   let userId = row["userId"] as? Int {
                   let dateFormatter = DateFormatter()
                   dateFormatter.dateFormat = "yyyy-MM-dd"
                    let createdDate = dateFormatter.date(from: createdDateString) ?? Date()
                    let updateddate = dateFormatter.date(from: updateDateString) ?? Date()
                    return .success(KnowledgeBase(id: id, title: title, issueType: IssueType(rawValue: issue) ?? IssueType.software, solution: solution, createdDate: createdDate, lastUpdatedDate: updateddate, userId: userId))
                } else {
                    return .failure(.executionFailed("Failed to extract user data."))
                }
                
            case .failure(let error):
                return .failure(error)
            }
            
        } catch {
            return .failure(.executionFailed("Unexpected error: \(error)"))
        }
    }
        
}
