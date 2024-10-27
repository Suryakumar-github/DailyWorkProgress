import UIKit

protocol Animal {
    var name: String { get }
    var diet: String { get }
}

struct Lion: Animal {
    let name = "Lion"
    let diet = "Carnivore"
}

struct Elephant: Animal {
    let name = "Elephant"
    let diet = "Herbivore"
}

protocol Enclosure {
    // The associated type is constrained to the Animal protocol
    associatedtype AnimalType: Animal
    var animals: [AnimalType] { get set }
    
    mutating func addAnimal(_ animal: AnimalType)
}

struct LionEnclosure: Enclosure {
    // Associated type is specified as Lion
    var animals = [Lion]()
    
    mutating func addAnimal(_ animal: Lion) {
        animals.append(animal)
    }
}

struct ElephantEnclosure: Enclosure {
    // Associated type is specified as Elephant
    var animals = [Elephant]()
    
    mutating func addAnimal(_ animal: Elephant) {
        animals.append(animal)
    }
}
class Zoo {
    var lionEnclosure = LionEnclosure()
    var elephantEnclosure = ElephantEnclosure()
    
    func addLion(_ lion: Lion) {
        lionEnclosure.addAnimal(lion)
    }
    
    func addElephant(_ elephant: Elephant) {
        elephantEnclosure.addAnimal(elephant)
    }
    
    func showAllAnimals() {
        print("Lions in the enclosure:")
        for lion in lionEnclosure.animals {
            print(" - \(lion.name), \(lion.diet)")
        }
        
        print("Elephants in the enclosure:")
        for elephant in elephantEnclosure.animals {
            print(" - \(elephant.name), \(elephant.diet)")
        }
    }
}
let zoo = Zoo()
zoo.addLion(Lion())
zoo.addElephant(Elephant())
zoo.showAllAnimals()
