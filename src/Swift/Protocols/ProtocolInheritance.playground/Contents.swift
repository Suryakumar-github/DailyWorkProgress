import UIKit

import Foundation

protocol Item {
    var title: String { get }
}

protocol Borrowable: Item {
    var borrowDuration: Int { get }
}

// Class-only protocol
protocol LibraryItem: AnyObject, Borrowable {
    func borrow() -> String
    func returnItem() -> String
}


// Book class conforming to LibraryItem
class Book: LibraryItem {
    let title: String
    let borrowDuration: Int
    private(set) var isBorrowed: Bool = false
    
    init(title: String, borrowDuration: Int) {
        self.title = title
        self.borrowDuration = borrowDuration
    }
    
    func borrow() -> String {
        guard !isBorrowed else { return "\(title) is already borrowed." }
        isBorrowed = true
        return "You have borrowed \(title) for \(borrowDuration) days."
    }
    
    func returnItem() -> String {
        guard isBorrowed else { return "\(title) was not borrowed." }
        isBorrowed = false
        return "\(title) has been returned. Thank you!"
    }
}

// Protocol Composition and Checking for Conformance

func displayBorrowInfo(for item: Item & Borrowable) {
    print("\(item.title) can be borrowed for \(item.borrowDuration) days.")
}

// Checking for protocol conformance in action
let myBook = Book(title: "Swift Programming", borrowDuration: 14)

if let borrowableItem = myBook as? Borrowable {
    displayBorrowInfo(for: borrowableItem)
}

print(myBook.borrow())
print(myBook.returnItem())
print(myBook.borrow())       

