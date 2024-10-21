import UIKit

class Book {
    // stored properties
    var title: String
    var author: String
    var totalPages: Int
    var currentPage: Int
    
    init(title: String, author: String, totalPages: Int, currentPage: Int) {
        self.title = title
        self.author = author
        self.totalPages = totalPages
        self.currentPage = currentPage
    }
    
    func read() {
        print("Reading the \(title) book")
    }
    // computed properties
    var readingProgress: String {
        get {
            let progress = Double(currentPage) / Double(totalPages) * 100
            return "Reading progress: \(progress)%"
        }
        set(newProgress) {
        
            if let percentIndex = newProgress.firstIndex(of: "%") {
                let progressValue = Double(newProgress[..<percentIndex]) ?? 0
                currentPage = Int((progressValue / 100) * Double(totalPages))
            }
        }
    }
}

class HarryPotter : Book, CustomStringConvertible {
    var price : Int
    init(title: String, author: String, totalPages: Int, currentPage: Int, price: Int) {
        self.price = price
        super.init(title: title, author: author,totalPages: totalPages,currentPage: currentPage)
    }
    
    func printer() {
        print(title)
    }
    
    override func read() {
        print("Reading the Harrypotter the \(title) book ")
    }
    
    var description :  String {
        return "\(title)  \(author)"
    }
    
}

let book = HarryPotter(title: "The Philospher Stone", author: "zoho", totalPages: 300, currentPage: 1, price: 1000)

book.read()
book.printer()
print(book)
var dummy = book.printer()
print(dummy)

var name1 : String = "zoho"
name1.append("corp")
name1 = name1 + "corp"
