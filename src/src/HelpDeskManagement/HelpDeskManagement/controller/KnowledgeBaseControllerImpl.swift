//
//  KnowledgeBaseControllerImpl.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//
import Foundation

class KnowledgeBaseControllerImpl : KnowledgeBaseController {
    
    func search(title: String, tag: String) -> KnowledgeBase? {
        let knowledgeBaseEntries = DataStorage.knowledgeBaseEntry
        
        for index in 0..<knowledgeBaseEntries.count {
            if knowledgeBaseEntries[index] != nil {
                if knowledgeBaseEntries[index]?.titleproperty == title && ((knowledgeBaseEntries[index]?.tagsProperty.contains(tag)) != nil) {
                    return knowledgeBaseEntries[index]
                }
            }
        }
        return nil
    }

    
    func addEntry(title: String, issueType : IssueType, solution: String, tags: [String], createdDate: Date, lastUpdatedDate: Date?) {
        let knowledgeBase = KnowledgeBase( title: title, issue: issueType, solution: solution, tags: tags, createdDate: createdDate, lastUpdatedDate: nil)
        DataStorage.knowledgeBaseEntry[knowledgeBase.getId] = knowledgeBase
    }
    
    func updateEntry(id: Int, solution: String, lastUpdatedDate: Date?) {
        let knowledgeBase = getKnowledgeBaseEntryById(id: id)
        knowledgeBase.solutionProperty = solution
        knowledgeBase.lastUpdatedDateProperty = lastUpdatedDate
    }
    
    func getKnowledgeBaseEntryById(id : Int) -> KnowledgeBase {
        let knowledgeBaseEntries = DataStorage.knowledgeBaseEntry
        return knowledgeBaseEntries[id]!
    }
}

