import UIKit

import UIKit

class Person {
    var name: String
    var age: Int

    init?(name: String, age: Int) {
        if name.isEmpty || age < 0 {
            return nil
        }
        self.name = name
        self.age = age
    }
}

class Employee: Person {

    override init?(name: String, age: Int) {
        // Call the superclass's failable initializer
        super.init(name: name, age: age)
    }
    
}

if let employee1 = Employee(name: "alex", age: 27) {
    print("Employee 1 created: \(employee1.name)")
} else {
    print("Failed to create Employee 1")
}

if let employee2 = Employee(name: "ram", age: 28) {
    print("Employee 2 created: \(employee2.name)")
} else {
    print("Failed to create Employee 2")
}

