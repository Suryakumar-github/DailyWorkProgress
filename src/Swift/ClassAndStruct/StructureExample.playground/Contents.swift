import UIKit

struct Animal: Equatable {
    var name: String
    var species: String
    var foodHabit: String
    
    func eat() {
        print("\(name) is eating")
    }
    
  /*  static func == (lhs: Animal, rhs: Animal) -> Bool {
        return lhs.name == rhs.name &&
               lhs.species == rhs.species &&
               lhs.foodHabit == rhs.foodHabit
    } */
}

var tiger = Animal(name: "tom", species: "Tiger", foodHabit: "Carnivores")
var lion = Animal(name: "leo", species: "Lion", foodHabit: "Carnivores")

tiger.eat()
lion.eat()

print(tiger == lion)

var anotherTiger = tiger
print(tiger == anotherTiger)

anotherTiger.name = "jerry"
print(tiger.name)
print(anotherTiger.name)
