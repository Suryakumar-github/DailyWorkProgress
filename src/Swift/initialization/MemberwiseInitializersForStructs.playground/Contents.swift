import UIKit

struct Book {
    var name : String
    var author : String
    var price : Int
    
}

var book = Book(name: "swift", author: "mathew", price: 1000)
print("Book Name : \(book.name), Author : \(book.author), Price : \(book.price) ")
