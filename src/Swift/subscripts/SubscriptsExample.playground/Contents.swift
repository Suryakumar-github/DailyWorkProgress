import UIKit

class Library {
    var books = ["book1" ,"book2", "book3", "book4", "book5"]
    
    subscript (index : Int) -> String {
        get {
            return books[index]
        }
        set {
            books[index] = newValue
        }
    }
    
    // read only subscript
    subscript(name : String) -> Int? {
        return books.firstIndex(of: name)
    }
}

var library = Library()
print(library[0])

library[0] = "Harry Potter"
print(library[0])
print(library["book3"]!)

// type subscript

enum Week : Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    
    static subscript (day : Int) -> Week {
        return Week(rawValue: day)!
    }
}

var day = Week[3]
print(day)

var day2 = Week(rawValue: 2)
print(day2!)
