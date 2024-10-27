import UIKit

class Person {
    let name: String
    var greeting: (() -> Void)?
    
    init(name: String) {
        self.name = name
        greeting = { [weak self] in
            guard let self = self else { return }
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

