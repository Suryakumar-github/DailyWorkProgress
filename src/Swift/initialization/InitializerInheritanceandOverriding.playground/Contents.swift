import UIKit

class ElectronicDevice {
    var modelName : String
    var price : Float
    var warrantyInYears : Int
    var color : String

    init(modelName : String, price : Float, warrantyInYears : Int, color: String) {
        self.modelName = modelName;
        self.price = price;
        self.warrantyInYears = warrantyInYears;
        self.color = color;

    }
    
    convenience init (modelName : String, price : Float) {
        self.init(modelName: modelName, price : price, warrantyInYears : 0, color : "")
    }
}

class Fan : ElectronicDevice {
    
}

var fan = Fan(modelName: "Super fan", price: 5000, warrantyInYears: 5, color: "Blue")
print(fan.color)
