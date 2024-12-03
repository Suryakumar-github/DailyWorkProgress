//
//  KnowledgeBaseControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//
import Foundation

class KnowledgeBaseControllerImpl : KnowledgeBaseController {
    
    let knowledgeBaseDao : KnowledgeBaseDAO = KnowledgeBaseDAOImpl()
    
    func search(word: String) throws -> [KnowledgeBase] {
        var knowledgeBaseEntries: [KnowledgeBase] = []
         
        let result = knowledgeBaseDao.getAllEntries()
        switch result {
            
        case .success(let entries) :
            for entry in entries {
                    
                if entry.titleproperty.lowercased().contains(word.lowercased()) {
                    knowledgeBaseEntries.append(entry)
                    continue
                }
                    
                if entry.issueProperty.rawValue.lowercased().contains(word.lowercased()) {
                    knowledgeBaseEntries.append(entry)
                    continue
                }
                    
                if entry.solutionProperty.lowercased().contains(word.lowercased()) {
                    knowledgeBaseEntries.append(entry)
                    continue
                }
                    
                if entry.tagsProperty.contains(where: { $0.lowercased().contains(word.lowercased()) }) {
                    knowledgeBaseEntries.append(entry)
                }
            }
            return knowledgeBaseEntries
            
        case .failure(let error) :
            throw error
        }
    }
  
    func addEntry(title: String, issueType : IssueType, solution: String, tags: [String], createdDate: Date, lastUpdatedDate: Date?, userId : Int) throws {
        let knowledgeBase = KnowledgeBase( title: title, issue: issueType, solution: solution, tags: tags, createdDate: createdDate, lastUpdatedDate: nil, userId: userId)
        let result = knowledgeBaseDao.addEntry(entry: knowledgeBase)
        switch result {
        case .success() :
            print("New Knowledge Base Entry Added")
        case .failure(let error) :
            throw error
        }
        try Logger.log(logType: LogType.info, message: "New Knowledge Base Entry Added with Id : \(knowledgeBase.getId)", userId: knowledgeBase.getId, data: knowledgeBase)
    }
    
    func updateEntry(id: Int, solution: String, lastUpdatedDate: Date?) throws {
        let knowledgeBase = try getKnowledgeBaseEntryById(id: id)
        knowledgeBase.solutionProperty = solution
        knowledgeBase.lastUpdatedDateProperty = lastUpdatedDate
        try Logger.log(logType: LogType.info, message: "Knowledge Base Entry Updated For id : \(id)", userId: knowledgeBase.getId, data: knowledgeBase)
    }
    
    func getKnowledgeBaseEntryById(id : Int) throws -> KnowledgeBase {
        let result = knowledgeBaseDao.getKnowledgeBaseEntryById(id: id)
        switch result {
        case .success(let knowledgeBase) :
            return knowledgeBase
            
        case .failure(let error) :
            throw error
        }
    }
    
    func getAllKnowledgeBaseEntries() throws -> [KnowledgeBase] {
        let result = knowledgeBaseDao.getAllEntries()
        switch result {
        case .success(let entries) :
            return entries
        case .failure( let error) :
            throw error
        }
    }
    
    deinit{
        
    }
}
