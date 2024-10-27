import UIKit

class Person {
    var name : String
    var age : Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    var bus : Bus?
    
    deinit{
        print("The Person \(name) is deinitialized")
    }
}

class Bus {
    var name : String
    var numberPlate : String
    init(name: String, numberPlate: String) {
        self.name = name
        self.numberPlate = numberPlate
    }
    
    var passanger : Person?
    
    deinit{
        print("The Bus \(name) is deinitialized")
    }
}

var person1 : Person? = Person(name: "surya", age: 23)
var bus1 : Bus? = Bus(name: "SETC", numberPlate: "TN 01 Ch 1001")

person1!.bus = bus1
bus1!.passanger = person1

print("Bus Name : \(person1?.bus) ")
print("Passenger Name : \(bus1!.passanger)")

person1 = nil
bus1 = nil

print("Bus Name : \(person1?.bus) ")
print("Passenger Name : \(bus1?.passanger)")
