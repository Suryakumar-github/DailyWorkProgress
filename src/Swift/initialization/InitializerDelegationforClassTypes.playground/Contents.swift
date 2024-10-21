import UIKit

 class Vechicle {
    var numberPlate : String
    var engineType : String
    
    init(numberPlate: String, engineType: String) {
        self.numberPlate = numberPlate
        self.engineType = engineType
    }
    
    func start() {
        print("Vechicle Started")
    }
    
    func stop() {
        print("Vechile Stopped")
    }
}

class Bike : Vechicle {
    var color : String
    var fuelCapacity : Int
    
    init(numberPlate : String, engineType : String, color: String, fuelCapacity: Int) {
        //  safety check1 & phase1
        self.color = color
        self.fuelCapacity = fuelCapacity
        //self.numberPlate = "TN 01 YZ 1001" -> 'self' used in property access 'numberPlate' before 'super.init' call
        //  safety check1
        super.init(numberPlate: numberPlate, engineType: engineType)
        // phase2
        self.numberPlate = "TN 01 YZ 1001"
    }
    
    convenience init() {
        self.init(numberPlate: "TN 00 AZ 1234", engineType: "petrol", color: "black", fuelCapacity: 0)
    }
}
