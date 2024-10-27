import UIKit

protocol Animal {
    var name: String { get }
    var isHerbivore: Bool { get }
    func makeSound()
}

struct Lion: Animal {
    var name: String = "Lion"
    var isHerbivore: Bool = false
    
    func makeSound() {
        print("\(name) roars!")
    }
}

struct Elephant: Animal {
    var name: String = "Elephant"
    var isHerbivore: Bool = true
    
    func makeSound() {
        print("\(name) trumpets!")
    }
}

// Generic type
struct Cage<T: Animal> {
    private var animals: [T] = []
    // Generic functions
    mutating func addAnimal(_ animal: T) {
        animals.append(animal)
    }
    
    func getAllAnimals() -> [T] {
        return animals
    }
}

// Type constrains
func feedAnimals<T: Animal>(in cage: Cage<T>) {
    for animal in cage.getAllAnimals() {
        print("Feeding \(animal.name)")
    }
}

// Extending a Generic Type with a Type Constraint

extension Cage {
    func areAllHerbivores() -> Bool {
        return animals.allSatisfy { $0.isHerbivore }
    }
}

var lionCage = Cage<Lion>()
lionCage.addAnimal(Lion())
feedAnimals(in: lionCage)

print("Are all lions herbivores?", lionCage.areAllHerbivores())

var elephantCage = Cage<Elephant>()
elephantCage.addAnimal(Elephant())
feedAnimals(in: elephantCage)
print("Are all elephants herbivores?", elephantCage.areAllHerbivores())
