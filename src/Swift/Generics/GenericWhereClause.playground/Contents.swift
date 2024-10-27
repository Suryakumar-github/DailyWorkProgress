import UIKit

protocol Book {
    var title: String { get }
    var author: String { get }
}

struct FictionBook: Book {
    var title: String
    var author: String
    var genre: String
}

struct ScienceBook: Book {
    var title: String
    var author: String
    var field: String
}

// Class with Generic Constraints

class Library<BookType: Book> {
    private var books: [BookType] = []
    
    func addBook(_ book: BookType) {
        books.append(book)
        print("Added '\(book.title)' to the library.")
    }
    
    func listBooks() -> [BookType] {
        return books
    }
}

// Extensions with a Generic Where Clause
extension Library where BookType == FictionBook {
    func describeFictionBooks() {
        print("Listing all fiction books:")
        for book in books {
            print("Title: \(book.title), Genre: \(book.genre)")
        }
    }
}

extension Library where BookType == ScienceBook {
    func describeScienceBooks() {
        print("Listing all science books:")
        for book in books {
            print("Title: \(book.title), Field: \(book.field)")
        }
    }
}

let fictionLibrary = Library<FictionBook>()
fictionLibrary.addBook(FictionBook(title: "The Hobbit", author: "J.R.R. Tolkien", genre: "Fantasy"))

let scienceLibrary = Library<ScienceBook>()
scienceLibrary.addBook(ScienceBook(title: "Cosmos", author: "Carl Sagan", field: "Astronomy"))

fictionLibrary.describeFictionBooks()
scienceLibrary.describeScienceBooks()

