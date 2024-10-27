import UIKit

import Foundation

protocol Vehicle {
    // Property Requirements
    var make: String { get }
    var model: String { get }
    var year: Int { get set }
    var isRunning: Bool { get set }
    
    // Method Requirements
    func startEngine() -> String
    func stopEngine() -> String
    
    // Mutating Method Requirement
    mutating func accelerate()
    mutating func brake()
    
    // Initializer Requirement
    init(make: String, model: String, year: Int)
    
    // Failable Initializer Requirement
    init?(make: String, model: String, year: Int, runningStatus: Bool)
}

class Car: Vehicle {
    // Properties
    var make: String
    var model: String
    var year: Int
    var isRunning: Bool = false
    
    // Required initializer
    required init(make: String, model: String, year: Int) {
        self.make = make
        self.model = model
        self.year = year
    }
    
    // Failable initializer
    required init?(make: String, model: String, year: Int, runningStatus: Bool) {
        guard year > 1885 else { return nil }
        self.make = make
        self.model = model
        self.year = year
        self.isRunning = runningStatus
    }
    
    // Method to start the engine
    func startEngine() -> String {
        isRunning = true
        return "The engine has started."
    }
    
    // Method to stop the engine
    func stopEngine() -> String {
        isRunning = false
        return "The engine has stopped."
    }
    
    // Mutating method to accelerate
    func accelerate() {
        if isRunning {
            print("The car is accelerating.")
        } else {
            print("Start the engine first.")
        }
    }
    
    // Mutating method to brake
    func brake() {
        if isRunning {
            print("The car is slowing down.")
        } else {
            print("The car is already stopped.")
        }
    }
}

// Creating instances using both initializers
let car1 = Car(make: "Toyota", model: "Innova", year: 2010)
print(car1?.startEngine() ?? "Initialization failed.")

if let car2 = Car(make: "Mahindra", model: "Thar", year: 1885, runningStatus: true) {
    print(car2.startEngine())
} else {
    print("Initialization failed.")
}

