//
//  KnowledgeBaseController.swift
//  HelpDeskManagement
//
//  Created by incubation on 06/11/24.
//
import Foundation

protocol KnowledgeBaseController : AnyObject{
    func search( title: String, tag : String) -> KnowledgeBase?
    func addEntry(title: String, issueType : IssueType, solution: String, tags: [String], createdDate: Date, lastUpdatedDate: Date?)
    func updateEntry(id : Int, solution: String, lastUpdatedDate: Date?)
}
