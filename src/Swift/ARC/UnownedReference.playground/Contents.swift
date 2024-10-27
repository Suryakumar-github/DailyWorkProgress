import UIKit

class Car {
    var carBrand : String
    var carName : String
    var engine : Engine?
    init(carBrand: String, carName: String) {
        self.carBrand = carBrand
        self.carName = carName
    }
    
    deinit {
        print("The \(carName) Car is deinitailized")
    }
}

class Engine {
    var enginetype : String
    var fuelCapacity : String
    unowned var car : Car
    
    init(enginetype: String, fuelCapacity: String, car : Car) {
        self.enginetype = enginetype
        self.fuelCapacity = fuelCapacity
        self.car = car
    }
    
    deinit {
        print("The \(enginetype) Engine is deinitailized")
    }
}

var newCar : Car? = Car(carBrand: "Tata", carName: "safari")
var newEngine : Engine? = Engine(enginetype: "Petrol", fuelCapacity: "35L", car: newCar!)
newCar?.engine = newEngine
//newCar?.engine =  Engine(enginetype: "Petrol", fuelCapacity: "35L", car: newCar!)
print(newCar!.engine!.enginetype)

newCar = nil
//print(newEngine!.enginetype)
