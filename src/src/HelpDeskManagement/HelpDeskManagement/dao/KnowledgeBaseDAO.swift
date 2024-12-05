//
//  Untitled.swift
//  HelpDeskManagement
//
//  Created by incubation on 26/11/24.
//

import Foundation

protocol KnowledgeBaseDAO {
    func addEntry(entry: KnowledgeBase) -> Result<Void, DatabaseError>
    func getAllEntries() throws -> Result<[KnowledgeBase], DatabaseError>
    func updateEntry(id: Int, solution: String, lastUpdatedDate: Date?) -> Result<Void, DatabaseError>
    func getKnowledgeBaseEntryById(id: Int) -> Result<KnowledgeBase, DatabaseError>
}
