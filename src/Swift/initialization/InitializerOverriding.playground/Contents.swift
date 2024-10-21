import UIKit

class ElectronicDevice {
    var modelName: String
    var price: Float
    var warrantyInYears: Int
    var color: String

    // Designated initializer
    init(modelName: String, price: Float, warrantyInYears: Int, color: String) {
        self.modelName = modelName
        self.price = price
        self.warrantyInYears = warrantyInYears
        self.color = color
    }

    // Convenince initializer
    convenience init(modelName: String, price: Float) {
        self.init(modelName: modelName, price: price, warrantyInYears: 0, color: "")
    }
}

class WashingMachine: ElectronicDevice {
    var brandName: String
    var capacity: Int
    var loadingType: String

    // Overriding the designated initializer
    override init(modelName: String, price: Float, warrantyInYears: Int, color: String) {
        // Set subclass-specific properties
        self.brandName = "Unknown"
        self.capacity = 0
        self.loadingType = "Top"

        // Call the superclass's designated initializer
        super.init(modelName: modelName, price: price, warrantyInYears: warrantyInYears, color: color)
    }
    
    init(brandName: String, capacity: Int, loadingType: String, modelName: String, price: Float, warrantyInYears: Int, color: String) {
        // Set subclass-specific properties
        self.brandName = brandName
        self.capacity = capacity
        self.loadingType = loadingType
        
        // Call the superclass's designated initializer
        super.init(modelName: modelName, price: price, warrantyInYears: warrantyInYears, color: color)
    }

}

let washingMachine = WashingMachine(brandName: "LG", capacity: 10, loadingType: "Front", modelName: "LG_Sharp", price: 15000.0, warrantyInYears: 2, color: "White")
print("Washing Machine brand: \(washingMachine.brandName), model: \(washingMachine.modelName), price: \(washingMachine.price)")
