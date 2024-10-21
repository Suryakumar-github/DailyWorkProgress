import UIKit

import UIKit

class Book {
    let title: String
    let author: String
    
    init(title: String, author: String) {
        self.title = title
        self.author = author
        print("\(title) by \(author)")
    }
    
    deinit {
        print("\(title) by \(author) is being deallocated")
    }
}

class Library {
    var book: Book?
    
    init(book: Book) {
        self.book = book
        print("Library with book: \(book.title)")
    }
    
    deinit {
        print("Library instance is being deallocated")
    }
}

if true {
    let library = Library(book: Book(title: "Swift Programming", author: "George"))
    print("Library is currently in use")

}

