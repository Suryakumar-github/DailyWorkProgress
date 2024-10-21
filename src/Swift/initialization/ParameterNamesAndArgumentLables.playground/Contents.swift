import UIKit

class Person {
    var name : String
    var gender : String
    var age : Int
    // optional type
    var marriedStatus : Bool?
    
    // init with argument lable
    init(personsName name: String,personsGender gender: String,personsAge age: Int, marriedStatus : Bool) {
        self.name = name
        self.gender = gender
        self.age = age
        self.marriedStatus = marriedStatus
    }
    
    // init withiut argument lable
    init(_ name: String, _ gender: String, _ age : Int) {
        self.name = name
        self.gender = gender
        self.age = age
    }
}

var person1 = Person(personsName: "Ak", personsGender: "Male", personsAge: 52, marriedStatus: true)
print(person1.age)

var person2 = Person("Sk", "Male", 35)
print(person2.marriedStatus)
