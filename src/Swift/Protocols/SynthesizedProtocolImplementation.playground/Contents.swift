import UIKit

import Foundation

protocol Vehicle {
    var name: String { get }
    var numberOfWheels: Int { get }
    
    func description() -> String
}

struct Car: Vehicle {
    var name: String
    var numberOfWheels: Int = 4
    
    func description() -> String {
        return "\(name) is a car with \(numberOfWheels) wheels."
    }
}

struct Bike: Vehicle {
    var name: String
    var numberOfWheels: Int = 2
    
    func description() -> String {
        return "\(name) is a bike with \(numberOfWheels) wheels."
    }
}

struct Truck: Vehicle {
    var name: String
    var numberOfWheels: Int = 6  
    
    func description() -> String {
        return "\(name) is a truck with \(numberOfWheels) wheels."
    }
}

let vehicles: [Vehicle] = [
    Car(name: "Toyota"),
    Bike(name: "Harley"),
    Truck(name: "Volvo")
]


for vehicle in vehicles {
    print(vehicle.description())
}

