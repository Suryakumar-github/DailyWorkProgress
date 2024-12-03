import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    let db: OpaquePointer?

    private init() {
        let fileManager = FileManager.default
        let documentDirectory = try? fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        guard let dbPath = documentDirectory?.appendingPathComponent("HelpDeskManagement.db").path else {
            db = nil
            print("Unable to resolve database path.")
            return
        }

        var database: OpaquePointer?
        if sqlite3_open(dbPath, &database) == SQLITE_OK {
            db = database
            print("Successfully connected to database at \(dbPath)")
        } else {
            db = nil
            print("Unable to open database at \(dbPath). Error: \(String(cString: sqlite3_errmsg(database)))")
            return
        }
    }

    deinit {
        if db != nil {
            sqlite3_close(db)
        }
    }
}
