//
//  KnowledgeBase.swift
//  HelpDeskManagement
//
//  Created by incubation on 04/11/24.
//
import Foundation

class KnowledgeBase {
    
    private let id: Int
    private var title: String
    private var issue : IssueType
    private var solution: String
    private var tags: [String]
    private let createdDate: Date
    private var lastUpdatedDate: Date?
    private static var idCount = 0
    
    init(title: String, issue: IssueType, solution: String, tags: [String], createdDate: Date, lastUpdatedDate: Date? = nil) {
        KnowledgeBase.idCount += 1
        self.id = KnowledgeBase.idCount
        self.title = title
        self.issue = issue
        self.solution = solution
        self.tags = tags
        self.createdDate = createdDate
        self.lastUpdatedDate = lastUpdatedDate
    }
    
    var getId : Int {
        return id
    }
    var titleproperty : String {
        get {
            return title
        }
        set(newTitle) {
            title = newTitle
        }
    }
    var issueProperty : IssueType {
        get {
            return issue
        }
        set(newIssue) {
            issue = newIssue
        }
    }
    var solutionProperty : String {
        get {
            return solution
        }
        set(newSolution) {
            solution = newSolution
        }
    }
    var tagsProperty : [String] {
        get {
            return tags
        }
        set(newTags) {
            tags = newTags
        }
    }
    func addtags(tag : String ) {
        tags.append(tag)
    }
    var getCreatedDate : Date {
        return createdDate
    }
    
    var lastUpdatedDateProperty : Date? {
        get {
            if let newLastUpdatedDate = lastUpdatedDate {
                return newLastUpdatedDate
            }
            else {
                return nil
            }
        }
        
        set(newLastUpdatedDate) {
            lastUpdatedDate = newLastUpdatedDate
        }
    }    
}
