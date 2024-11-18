//
//  KnowledgeBaseControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//
import Foundation

class KnowledgeBaseControllerImpl : KnowledgeBaseController {
    
    func search(title: String, tag: String) -> KnowledgeBase? {
        for entry in DataStorage.knowledgeBaseEntry.values {
            if entry.tagsProperty.contains(tag) {
                return entry
            }
        }
        return nil
    }
  
    func addEntry(title: String, issueType : IssueType, solution: String, tags: [String], createdDate: Date, lastUpdatedDate: Date?) {
        let knowledgeBase = KnowledgeBase( title: title, issue: issueType, solution: solution, tags: tags, createdDate: createdDate, lastUpdatedDate: nil)
        DataStorage.knowledgeBaseEntry[knowledgeBase.getId] = knowledgeBase
        Logger.log(logType: LogType.info, message: "New Knowledge Base Entry Added with Id : \(knowledgeBase.getId)", userId: knowledgeBase.getId, data: knowledgeBase)
    }
    
    func updateEntry(id: Int, solution: String, lastUpdatedDate: Date?) {
        let knowledgeBase = getKnowledgeBaseEntryById(id: id)
        knowledgeBase.solutionProperty = solution
        knowledgeBase.lastUpdatedDateProperty = lastUpdatedDate
        Logger.log(logType: LogType.info, message: "Knowledge Base Entry Updated For id : \(id)", userId: knowledgeBase.getId, data: knowledgeBase)
    }
    
    func getKnowledgeBaseEntryById(id : Int) -> KnowledgeBase {
        let knowledgeBaseEntries = DataStorage.knowledgeBaseEntry
        return knowledgeBaseEntries[id]!
    }
    deinit{
        
    }
}
