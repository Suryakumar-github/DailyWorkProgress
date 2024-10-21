import UIKit
/*
struct Mobile {
    let brandName : String
    let modelName : String
    let batteryCapacity : Int
    let frontCamera : String
    let backCamera : String
    
    init(brandName: String, modelName: String, batteryCapacity: Int, frontCamera: String, backCamera: String) {
        self.brandName = brandName
        self.modelName = modelName
        self.batteryCapacity = batteryCapacity
        self.frontCamera = frontCamera
        self.backCamera = backCamera
    }
    
    init(brandName : String, modelName : String, batteryCapacity : Int, backCamera : String) {
        self.init(brandName: brandName, modelName: modelName, batteryCapacity: batteryCapacity, frontCamera: "", backCamera: backCamera)
    }
    
    init(brandName : String, modelName : String, batteryCapacity : Int) {
        self.init(brandName: brandName, modelName: modelName, batteryCapacity: batteryCapacity, frontCamera: "", backCamera: "")
    }
    
    init( modelName : String, batteryCapacity : Int) {
        self.init(brandName: "", modelName: modelName, batteryCapacity: batteryCapacity, frontCamera: "", backCamera: "")
        self.init(brandName: "", modelName: modelName, batteryCapacity: batteryCapacity)
    }
    
}

var mobile = Mobile(modelName: "xperia", batteryCapacity: 3000)
print("Mobile's Model name \(mobile.modelName) ")
*/

import UIKit

class Mobile {
    let brandName : String
    let modelName : String
    let batteryCapacity : Int
    let frontCamera : String
    let backCamera : String
    
    init(brandName: String, modelName: String, batteryCapacity: Int, frontCamera: String, backCamera: String) {
        self.brandName = brandName
        self.modelName = modelName
        self.batteryCapacity = batteryCapacity
        self.frontCamera = frontCamera
        self.backCamera = backCamera
    }
    
    convenience init(brandName : String, modelName : String, batteryCapacity : Int, backCamera : String) {
        self.init(brandName: brandName, modelName: modelName, batteryCapacity: batteryCapacity, frontCamera: "", backCamera: backCamera)
    }
    
//    convenience init(brandName : String, modelName : String, batteryCapacity : Int) {
//       // self.init(brandName: brandName, modelName: modelName, batteryCapacity: batteryCapacity, frontCamera: "", backCamera: "")
//    }
    
    convenience init( modelName : String, batteryCapacity : Int) {
        self.init(brandName: "", modelName: modelName, batteryCapacity: batteryCapacity, frontCamera: "", backCamera: "")
       // self.init(brandName: "", modelName: modelName, batteryCapacity: batteryCapacity)
    }
    
}

var mobile = Mobile(modelName: "xperia", batteryCapacity: 3000)
print("Mobile's Model name \(mobile.modelName) ")
