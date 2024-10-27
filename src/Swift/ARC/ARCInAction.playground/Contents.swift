import UIKit

class Animal {
    var species : String
    var age : Int
    init(species: String, age: Int) {
        self.species = species
        self.age = age
        
        print("Initialization of Animal \(species) is Completed..")
    }
    
    deinit{
        print("Deinitialization of Animal \(species) ..")
    }
}

var animal1 : Animal? = Animal(species: "Lion", age: 10)
var animal2 : Animal? = animal1
var animal3 : Animal? = animal1

animal1 = nil
print(animal1?.species ?? "Default Animal Object ")
print(animal2?.species ?? "Default Animal Object ")

animal2 = nil
print(animal2?.species ?? "Default Animal Object ")

animal3 = nil
print(animal2?.species ?? "Default Animal Object ")
