import UIKit
class Owner {
    var car: Car?
}

class Car {
    var model: String
    var year: Int
    var parts: [Part?] = []

    init(model: String, year: Int) {
        self.model = model
        self.year = year
    }
    
    func printCarInfo() {
        print("Car model: \(model), Year: \(year)")
    }
}

class Part {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

let owner = Owner()

//owner.car!.printCarInfo()

// Calling methods through optional chaining
if owner.car?.printCarInfo() != nil {
    print("It was possible to print the car info.")
} else {
    print("It was not possible to print the car info.")
}

owner.car = Car(model: "Tata Safari", year: 2022)

if owner.car?.printCarInfo() != nil {
    print("It was possible to print the car info.")
} else {
    print("It was not possible to print the car info.")
}

// Attempting to set a property through optional chaining
if (owner.car?.year = 2023) != nil {
    print("It was possible to update the car year.")
} else {
    print("It was not possible to update the car year.")
}

// Accessing Subscripts Through Optional Chaining
owner.car?.parts.append(Part(name: "Engine"))
owner.car?.parts.append(Part(name: "Wheels"))

if let firstPartName = owner.car?.parts[0]?.name {
    print("The first part is \(firstPartName).")
} else {
    print("Unable to retrieve the first part.")
}

owner.car?.parts[1] = Part(name: "New Wheels")

if let secondPartName = owner.car?.parts[1]?.name {
    print("The second part is \(secondPartName).")
} else {
    print("Unable to retrieve the second part.")
}
