//
//  QueryGenerator.swift
//  HelpDeskManagement
//
//  Created by incubation on 04/12/24.
//
import SQLite3
import Foundation

struct QueryGenerator {
    static func queryGenerator(baseQuery: String, data: [Any]) throws -> String {
        var query = baseQuery
        for value in data {
            let replacement: String
            switch value {
            case let text as String:
                replacement = "'\(text.replacingOccurrences(of: "'", with: "''"))'"
            case let int as Int:
                replacement = "\(int)"
            case let double as Double:
                replacement = "\(double)"
            case let bool as Bool:
                replacement = bool ? "1" : "0"
            case is NSNull:
                replacement = "NULL"
            default:
                throw DatabaseError.executionFailed("Unsupported data type for value: \(value)")
            }
            if let range = query.range(of: "?") {
                query.replaceSubrange(range, with: replacement)
            } else {
                throw DatabaseError.executionFailed("Not enough placeholders in query.")
            }
        }
        return query
    }
}

