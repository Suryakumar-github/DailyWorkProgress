import UIKit

import Foundation
struct Person: Equatable, Comparable {
    let name: String
    let age: Int
    
}

extension Person {
    static func < (lhs: Person, rhs: Person) -> Bool {
        return lhs.age < rhs.age
    }
}

let person1 = Person(name: "Alex", age: 25)
let person2 = Person(name: "Rayappan", age: 50)
let person3 = Person(name: "Michale", age: 25)
let person4 = Person(name: "Alex", age: 25)

print(person1 == person4)
print(person1 == person2)

print(person1 < person2)

let people = [person1, person2, person3]
let sortedPeople = people.sorted()
for person in sortedPeople {
    print("\(person.name) - Age: \(person.age)")
}

