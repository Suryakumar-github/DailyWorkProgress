//
//  KnowledgeBase.swift
//  HelpDeskManagement
//
//  Created by incubation on 04/11/24.
//
import Foundation

class KnowledgeBase {
    
    private var id: Int
    private var title: String
    private var issue : IssueType
    private var solution: String
    private let createdDate: Date
    private var lastUpdatedDate: Date?
    private let userId : Int
    private static var idCount = 0
    
    init(title: String, issue: IssueType, solution: String, createdDate: Date, lastUpdatedDate: Date? = nil, userId : Int) {
        KnowledgeBase.idCount += 1
        self.id = KnowledgeBase.idCount
        self.title = title
        self.issue = issue
        self.solution = solution
        self.createdDate = createdDate
        self.lastUpdatedDate = lastUpdatedDate
        self.userId = userId
    }
    
    convenience init (id: Int, title: String, issueType: IssueType, solution: String, createdDate: Date, lastUpdatedDate: Date, userId: Int) {
        self.init(title: title, issue: issueType, solution: solution, createdDate: createdDate, lastUpdatedDate: lastUpdatedDate, userId: userId)
        self.id = id
    }
    
    var getId : Int {
        return id
    }
    
    var getUserId : Int {
        return userId
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

extension KnowledgeBase: Loggable {
    var logType: LogType {
        return .info
    }
    
    var logMessage: String {
        return ""
    }
    
    var logId : Int {
        return self.getId
    }
}
