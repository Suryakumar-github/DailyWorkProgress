import UIKit

//instance metods

class Car {
    var speed = 0
    
    func accelerate() {
        speed += 10
        print("Accelerating to \(speed) km/h")
    }
    
    func brake() {
        speed -= 10
        print("Braking to \(speed) km/h")
    }
}

let myCar = Car()
myCar.accelerate()
myCar.accelerate()
myCar.brake()

// mutating methods

struct Bike {
    var speed = 0
    
    mutating func accelerate() {
        speed += 10
        print("Accelerating to \(speed) km/h")
    }
    
    mutating func brake() {
        speed -= 10
        print("Braking to \(speed) km/h")
    }
}
print(".........")
var bike = Bike()
bike.accelerate()
print(bike.speed)
print(bike)

// self

struct Person {
    var name : String
    var age : Int
    
    init (name : String, age : Int) {
        self.age = age
        self.name = name
    }
    
    mutating func changePersonality(name : String, age : Int) {
        self = Person(name: name, age: age)
    }
}

var person1 = Person(name: "surya", age: 23)
print(person1.self)
person1.changePersonality(name: "amar", age: 20)
print(person1)

enum Direction {
    case north, east, west, south
    
    mutating func changeDirection()
    {
        switch self {
        case .north :
            self = .east
            
        case .east :
            self = .west
            
        case .west :
            self = .south
            
        case .south :
            self = .north
        }
    }
    
}

var direction = Direction.east
print("Direction is : \(direction) ")
direction.changeDirection()
print("Direction is : \(direction) ")


// type methods
class Bird {
    var name: String
    var color: String
    
    init(name: String, color: String) {
        self.name = name
        self.color = color
    }
    
    func describe() {
        print("Name: \(name) and Color: \(color)")
    }
    
    class func describe() {
        print("The bird is now eating")
    }
}

Bird.describe()

let parrot = Bird(name: "Parrot", color: "Green")
parrot.describe()

}
