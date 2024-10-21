import UIKit

class Bird {
    var name : String
    var species : String
    
    init(name: String, species: String) {
        self.name = name
        self.species = species
    }
    
    func eat() {
        print("\(name) is eating ")
    }
    
}

var dove = Bird(name: "hukum", species: "Dove")
dove.eat()

var parrot = Bird(name: "lee", species: "Parrot")
parrot.eat()

print(dove === parrot)

var anotherDove = dove
print(dove === anotherDove)

print(dove.name)
anotherDove.name = "lord"
print(anotherDove.name)
print(dove.name)
