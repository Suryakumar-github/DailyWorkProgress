import UIKit

class Person {
    let name: String
    var greeting: (() -> Void)?
    
    init(name: String) {
        self.name = name
        greeting = { [unowned self] in
            print("Hello, \(self.name)!")
        }
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

var person: Person? = Person(name: "Alice")
person?.greeting?()
person = nil       
