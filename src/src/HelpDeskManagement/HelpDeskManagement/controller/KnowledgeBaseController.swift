//
//  KnowledgeBaseController.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//
import Foundation

protocol KnowledgeBaseController : AnyObject{
    func search(word: String) throws -> [KnowledgeBase]
    func addEntry(title: String, issueType : IssueType, solution: String, createdDate: Date, lastUpdatedDate: Date?, userId : Int)throws -> Bool
    func updateEntry(id: Int, solution: String, lastUpdatedDate: Date?) throws
    func getAllKnowledgeBaseEntries() throws -> [KnowledgeBase]
}
